const express = require('express');
const http = require('http');
const { Server } = require('socket.io');
const sqlite3 = require('sqlite3').verbose();
const path = require('path');

const app = express();
const server = http.createServer(app);
const io = new Server(server);

const db = new sqlite3.Database('./session.db');

// Setup DB
db.serialize(() => {
    db.run("CREATE TABLE IF NOT EXISTS teams (id INTEGER PRIMARY KEY, name TEXT, score INTEGER DEFAULT 0)");
    db.run("CREATE TABLE IF NOT EXISTS students (id TEXT PRIMARY KEY, team_id INTEGER)");
    db.run("CREATE TABLE IF NOT EXISTS answers (student_id TEXT, module TEXT, question_id TEXT, answer TEXT)");
    
    // Initialize teams if empty
    db.get("SELECT count(*) as count FROM teams", (err, row) => {
        if (row && row.count === 0) {
            const stmt = db.prepare("INSERT INTO teams (id, name, score) VALUES (?, ?, ?)");
            for (let i = 1; i <= 12; i++) {
                stmt.run(i, `Team ${i}`, 0);
            }
            stmt.finalize();
        }
    });
});

app.use(express.static(path.join(__dirname, 'public')));
app.use(express.json());

// Global state
let sessionState = {
    timerSecs: 0,
    isRunning: false,
    activeTab: 'mod1',
    currentPhase: 'WELCOME & HOOK'
};

let gandalfLevel = 0;

// Socket IO Logic
io.on('connection', (socket) => {
    console.log(`User connected: ${socket.id}`);
    
    // Send current state
    socket.emit('state_update', sessionState);
    
    // Send team scores
    db.all("SELECT * FROM teams", (err, rows) => {
        socket.emit('teams_update', rows);
    });

    socket.on('join_team', (teamId) => {
        db.run("INSERT OR REPLACE INTO students (id, team_id) VALUES (?, ?)", [socket.id, teamId], () => {
            socket.join(`team_${teamId}`);
            console.log(`Student ${socket.id} joined Team ${teamId}`);
            socket.emit('joined_team', teamId);
        });
    });

    // Facilitator controls
    socket.on('set_timer', (secs) => {
        sessionState.timerSecs = secs;
        io.emit('state_update', sessionState);
    });

    socket.on('set_active_tab', (tab) => {
        sessionState.activeTab = tab;
        io.emit('state_update', sessionState);
    });

    socket.on('award_points', (data) => {
        // data: { teamId, points, reason }
        db.run("UPDATE teams SET score = score + ? WHERE id = ?", [data.points, data.teamId], () => {
            db.all("SELECT * FROM teams", (err, rows) => {
                io.emit('teams_update', rows);
            });
            // Also notify that team
            io.to(`team_${data.teamId}`).emit('points_awarded', { points: data.points, reason: data.reason });
        });
    });

    // Student interactions
    socket.on('submit_answer', (data) => {
        // data: { module, question_id, answer }
        db.get("SELECT team_id FROM students WHERE id = ?", [socket.id], (err, row) => {
            if (row) {
                db.run("INSERT INTO answers (student_id, module, question_id, answer) VALUES (?, ?, ?, ?)", [socket.id, data.module, data.question_id, data.answer], () => {
                    // Tell facilitator about answer
                    io.emit('student_answered', { team_id: row.team_id, module: data.module, question_id: data.question_id, answer: data.answer });
                });
            }
        });
    });

    socket.on('disconnect', () => {
        console.log(`User disconnected: ${socket.id}`);
    });
});

const PORT = 3000;
server.listen(PORT, () => {
    console.log(`Server listening on http://localhost:${PORT}`);
});
