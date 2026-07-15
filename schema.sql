-- Supabase Schema for Live Session Console

-- 1. CLEANUP (Drop existing tables if any)
DROP TABLE IF EXISTS answers CASCADE;
DROP TABLE IF EXISTS students CASCADE;
DROP TABLE IF EXISTS teams CASCADE;
DROP TABLE IF EXISTS session_state CASCADE;
DROP TABLE IF EXISTS schedule CASCADE;
DROP TABLE IF EXISTS board_items CASCADE;
DROP TABLE IF EXISTS mails CASCADE;
DROP TABLE IF EXISTS clips CASCADE;
DROP TABLE IF EXISTS stations CASCADE;
DROP TABLE IF EXISTS quiz_questions CASCADE;

-- 2. CREATE STATE & USERS TABLES
CREATE TABLE teams (
    id INT PRIMARY KEY,
    name TEXT NOT NULL,
    score INT DEFAULT 0
);

CREATE TABLE students (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    team_id INT REFERENCES teams(id)
);

CREATE TABLE answers (
    id SERIAL PRIMARY KEY,
    team_id INT REFERENCES teams(id),
    module TEXT NOT NULL,
    question_id TEXT NOT NULL,
    answer TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT now()
);

CREATE TABLE session_state (
    id INT PRIMARY KEY DEFAULT 1,
    timer_secs INT DEFAULT 0,
    is_running BOOLEAN DEFAULT false,
    active_tab TEXT DEFAULT 'mod1',
    gandalf_level INT DEFAULT 0
);

-- Enable Realtime for answers, teams, and session_state
-- alter publication supabase_realtime add table answers;
-- alter publication supabase_realtime add table teams;
-- alter publication supabase_realtime add table session_state;

-- 3. CREATE DYNAMIC CONTENT TABLES
CREATE TABLE schedule (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    time_str TEXT NOT NULL,
    start_sec INT NOT NULL
);

CREATE TABLE board_items (
    id INT PRIMARY KEY,
    text TEXT NOT NULL,
    correct TEXT NOT NULL,
    status TEXT DEFAULT 'unsorted'
);

CREATE TABLE mails (
    id INT PRIMARY KEY,
    team_id INT NOT NULL,
    label TEXT NOT NULL,
    sender TEXT NOT NULL,
    body TEXT NOT NULL,
    correct TEXT NOT NULL,
    answered BOOLEAN DEFAULT false
);

CREATE TABLE clips (
    id INT PRIMARY KEY,
    label TEXT NOT NULL,
    title TEXT NOT NULL,
    correct TEXT NOT NULL,
    explanation TEXT NOT NULL,
    answered BOOLEAN DEFAULT false
);

CREATE TABLE stations (
    id INT PRIMARY KEY,
    name TEXT NOT NULL,
    is_active BOOLEAN DEFAULT false
);

CREATE TABLE quiz_questions (
    id INT PRIMARY KEY,
    text TEXT NOT NULL,
    options JSONB NOT NULL,
    answer INT NOT NULL,
    answered BOOLEAN DEFAULT false
);

-- Enable Realtime for dynamic content updates during session
-- alter publication supabase_realtime add table board_items;
-- alter publication supabase_realtime add table mails;
-- alter publication supabase_realtime add table clips;
-- alter publication supabase_realtime add table stations;
-- alter publication supabase_realtime add table quiz_questions;


-- 4. INSERT INITIAL DATA (Removing Mock Data from Code)

-- Teams
INSERT INTO teams (id, name, score) VALUES 
(1, 'Team 1', 0), (2, 'Team 2', 0), (3, 'Team 3', 0), (4, 'Team 4', 0),
(5, 'Team 5', 0), (6, 'Team 6', 0), (7, 'Team 7', 0), (8, 'Team 8', 0),
(9, 'Team 9', 0), (10, 'Team 10', 0), (11, 'Team 11', 0), (12, 'Team 12', 0);

-- Session State Initialization
INSERT INTO session_state (id, timer_secs, is_running, active_tab, gandalf_level) VALUES (1, 0, false, 'mod1', 0);

-- Schedule
INSERT INTO schedule (id, title, time_str, start_sec) VALUES 
('welcome', 'Welcome & hook', '0:00', 0),
('mod1', 'Mod 1 - Attack vs Defense', '0:10', 600),
('lab1', 'Lab 1 - AI Phishing', '0:40', 2400),
('break', 'Break', '1:15', 4500),
('lab2', 'Lab 2 - Prompt Injection', '1:25', 5100),
('lab3', 'Lab 3 - Deepfake Detection', '2:00', 7200),
('lab4', 'Lab 4 - Defensive Tools', '2:30', 9000),
('quiz', 'Quiz & wrap-up', '2:50', 10200);

-- Board Items
INSERT INTO board_items (id, text, correct, status) VALUES 
(1, 'AI-written phishing text', 'A', 'unsorted'),
(2, 'Deepfake voice cloning', 'A', 'unsorted'),
(3, 'AI-generated malware code', 'A', 'unsorted'),
(4, 'Automated vulnerability scanning', 'D', 'unsorted'),
(5, 'Anomaly / fraud scoring', 'D', 'unsorted'),
(6, 'Spam & phishing filters', 'D', 'unsorted'),
(7, 'SOC analyst copilots', 'D', 'unsorted'),
(8, 'Behavioral login detection', 'D', 'unsorted');

-- Mails (Team 0 = Facilitator Samples, Teams 1-12 = Unique student sets)
INSERT INTO mails (id, team_id, label, sender, body, correct, answered) VALUES 
(1, 0, 'S1', 'IT-Support@techk-nots.com', 'Urgent: Your account will be suspended in 2 hours. Verify your credentials immediately using the secure link below to avoid interruption.', 'PHISHING', false),
(2, 0, 'S2', 'placements@techknots.in', 'Hi all, attaching the confirmed schedule for next week''s VAC sessions. Let me know if your slot needs to move. No links, no attachments needed to open right away.', 'GENUINE', false),
(3, 0, 'S3', 'security-alert@paypa1-verify.com', 'Unusual sign-in detected — action required. We noticed a login from a new device. If this wasn''t you, click below within 30 minutes to secure your account before it is locked permanently.', 'PHISHING', false),
(4, 1, 'E1', 'support-1@techk-nots.com', 'Urgent action required for Team 1. Click here to secure your account.', 'PHISHING', false),
(5, 1, 'E2', 'hr@techknots.in', 'Team 1, here is the updated policy document for this quarter. No action needed.', 'GENUINE', false),
(6, 1, 'E3', 'alert-1@security-notify.com', 'New login detected on Team 1 dashboard. Verify identity immediately.', 'PHISHING', false),
(7, 2, 'E1', 'support-2@techk-nots.com', 'Urgent action required for Team 2. Click here to secure your account.', 'PHISHING', false),
(8, 2, 'E2', 'hr@techknots.in', 'Team 2, here is the updated policy document for this quarter. No action needed.', 'GENUINE', false),
(9, 2, 'E3', 'alert-2@security-notify.com', 'New login detected on Team 2 dashboard. Verify identity immediately.', 'PHISHING', false),
(10, 3, 'E1', 'support-3@techk-nots.com', 'Urgent action required for Team 3. Click here to secure your account.', 'PHISHING', false),
(11, 3, 'E2', 'hr@techknots.in', 'Team 3, here is the updated policy document for this quarter. No action needed.', 'GENUINE', false),
(12, 3, 'E3', 'alert-3@security-notify.com', 'New login detected on Team 3 dashboard. Verify identity immediately.', 'PHISHING', false),
(13, 4, 'E1', 'support-4@techk-nots.com', 'Urgent action required for Team 4. Click here to secure your account.', 'PHISHING', false),
(14, 4, 'E2', 'hr@techknots.in', 'Team 4, here is the updated policy document for this quarter. No action needed.', 'GENUINE', false),
(15, 4, 'E3', 'alert-4@security-notify.com', 'New login detected on Team 4 dashboard. Verify identity immediately.', 'PHISHING', false),
(16, 5, 'E1', 'support-5@techk-nots.com', 'Urgent action required for Team 5. Click here to secure your account.', 'PHISHING', false),
(17, 5, 'E2', 'hr@techknots.in', 'Team 5, here is the updated policy document for this quarter. No action needed.', 'GENUINE', false),
(18, 5, 'E3', 'alert-5@security-notify.com', 'New login detected on Team 5 dashboard. Verify identity immediately.', 'PHISHING', false),
(19, 6, 'E1', 'support-6@techk-nots.com', 'Urgent action required for Team 6. Click here to secure your account.', 'PHISHING', false),
(20, 6, 'E2', 'hr@techknots.in', 'Team 6, here is the updated policy document for this quarter. No action needed.', 'GENUINE', false),
(21, 6, 'E3', 'alert-6@security-notify.com', 'New login detected on Team 6 dashboard. Verify identity immediately.', 'PHISHING', false),
(22, 7, 'E1', 'support-7@techk-nots.com', 'Urgent action required for Team 7. Click here to secure your account.', 'PHISHING', false),
(23, 7, 'E2', 'hr@techknots.in', 'Team 7, here is the updated policy document for this quarter. No action needed.', 'GENUINE', false),
(24, 7, 'E3', 'alert-7@security-notify.com', 'New login detected on Team 7 dashboard. Verify identity immediately.', 'PHISHING', false),
(25, 8, 'E1', 'support-8@techk-nots.com', 'Urgent action required for Team 8. Click here to secure your account.', 'PHISHING', false),
(26, 8, 'E2', 'hr@techknots.in', 'Team 8, here is the updated policy document for this quarter. No action needed.', 'GENUINE', false),
(27, 8, 'E3', 'alert-8@security-notify.com', 'New login detected on Team 8 dashboard. Verify identity immediately.', 'PHISHING', false),
(28, 9, 'E1', 'support-9@techk-nots.com', 'Urgent action required for Team 9. Click here to secure your account.', 'PHISHING', false),
(29, 9, 'E2', 'hr@techknots.in', 'Team 9, here is the updated policy document for this quarter. No action needed.', 'GENUINE', false),
(30, 9, 'E3', 'alert-9@security-notify.com', 'New login detected on Team 9 dashboard. Verify identity immediately.', 'PHISHING', false),
(31, 10, 'E1', 'support-10@techk-nots.com', 'Urgent action required for Team 10. Click here to secure your account.', 'PHISHING', false),
(32, 10, 'E2', 'hr@techknots.in', 'Team 10, here is the updated policy document for this quarter. No action needed.', 'GENUINE', false),
(33, 10, 'E3', 'alert-10@security-notify.com', 'New login detected on Team 10 dashboard. Verify identity immediately.', 'PHISHING', false),
(34, 11, 'E1', 'support-11@techk-nots.com', 'Urgent action required for Team 11. Click here to secure your account.', 'PHISHING', false),
(35, 11, 'E2', 'hr@techknots.in', 'Team 11, here is the updated policy document for this quarter. No action needed.', 'GENUINE', false),
(36, 11, 'E3', 'alert-11@security-notify.com', 'New login detected on Team 11 dashboard. Verify identity immediately.', 'PHISHING', false),
(37, 12, 'E1', 'support-12@techk-nots.com', 'Urgent action required for Team 12. Click here to secure your account.', 'PHISHING', false),
(38, 12, 'E2', 'hr@techknots.in', 'Team 12, here is the updated policy document for this quarter. No action needed.', 'GENUINE', false),
(39, 12, 'E3', 'alert-12@security-notify.com', 'New login detected on Team 12 dashboard. Verify identity immediately.', 'PHISHING', false);

-- Clips
INSERT INTO clips (id, label, title, correct, explanation, answered) VALUES 
(1, 'Clip 1', 'CEO Quarterly Update Announcement', 'FAKE', 'Unnatural blinking pattern and audio artifact at 0:04.', false),
(2, 'Clip 2', 'Security Conference Keynote', 'REAL', 'Genuine footage from last year''s summit.', false);

-- Stations
INSERT INTO stations (id, name, is_active) VALUES 
(0, 'Have I Been Pwned', false),
(1, 'VirusTotal', false),
(2, 'Google Safe Browsing', false),
(3, 'Windows Defender', false);

-- Quiz
INSERT INTO quiz_questions (id, text, options, answer, answered) VALUES 
(1, 'What is Prompt Injection?', '["Bypassing filters via language input", "Injecting SQL commands", "Phishing via email", "A firewall rule"]', 0, false),
(2, 'Which tool scans files for known malware signatures?', '["Have I Been Pwned", "VirusTotal", "Gandalf", "Nmap"]', 1, false),
(3, 'A common visual tell for deepfakes is:', '["High resolution", "Perfect audio sync", "Unnatural blinking/teeth", "Black and white color"]', 2, false),
(4, 'AI is most effective for defenders in:', '["Writing malware", "Pattern recognition at scale", "Social engineering", "Physical security"]', 1, false),
(5, 'The goal of Gandalf was to:', '["Guess the password", "Bypass the LLM guardrails", "Detect deepfakes", "Sort attack vs defense"]', 1, false),
(6, 'Which domain is a typo-squatting example?', '["google.com", "microsoft.com", "paypa1.com", "techknots.in"]', 2, false);

-- Disable RLS to allow public frontend access without auth
ALTER TABLE teams DISABLE ROW LEVEL SECURITY;
ALTER TABLE students DISABLE ROW LEVEL SECURITY;
ALTER TABLE answers DISABLE ROW LEVEL SECURITY;
ALTER TABLE session_state DISABLE ROW LEVEL SECURITY;
ALTER TABLE schedule DISABLE ROW LEVEL SECURITY;
ALTER TABLE board_items DISABLE ROW LEVEL SECURITY;
ALTER TABLE mails DISABLE ROW LEVEL SECURITY;
ALTER TABLE clips DISABLE ROW LEVEL SECURITY;
ALTER TABLE stations DISABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_questions DISABLE ROW LEVEL SECURITY;
