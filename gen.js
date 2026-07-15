const fs = require('fs');

let sql = '';
let id = 4;
for (let t = 1; t <= 12; t++) {
    sql += `(${id++}, ${t}, 'E1', 'support-${t}@techk-nots.com', 'Urgent action required for Team ${t}. Click here to secure your account.', 'PHISHING', false),\n`;
    sql += `(${id++}, ${t}, 'E2', 'hr@techknots.in', 'Team ${t}, here is the updated policy document for this quarter. No action needed.', 'GENUINE', false),\n`;
    sql += `(${id++}, ${t}, 'E3', 'alert-${t}@security-notify.com', 'New login detected on Team ${t} dashboard. Verify identity immediately.', 'PHISHING', false),\n`;
}

// Remove last comma and add semicolon
sql = sql.slice(0, -2) + ';';
fs.writeFileSync('mails_insert.sql', sql);
console.log('Done');
