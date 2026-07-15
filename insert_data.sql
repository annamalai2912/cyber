-- 1. DISABLE RLS TEMPORARILY
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
ALTER TABLE materials DISABLE ROW LEVEL SECURITY;
ALTER TABLE osint_tasks DISABLE ROW LEVEL SECURITY;
ALTER TABLE teaching_slides DISABLE ROW LEVEL SECURITY;

-- 2. INSERT ALL MISSING DATA
INSERT INTO session_state (id, timer_secs, is_running, active_tab, gandalf_level) VALUES (1, 0, false, 'mod1', 0) ON CONFLICT (id) DO NOTHING;

INSERT INTO schedule (id, title, time_str, start_sec) VALUES 
('welcome', 'Welcome & hook', '0:00', 0),
('mod1', 'Mod 1 - Attack vs Defense', '0:10', 600),
('lab1', 'Lab 1 - AI Phishing', '0:40', 2400),
('break', 'Break', '1:15', 4500),
('lab2', 'Lab 2 - Prompt Injection', '1:25', 5100),
('lab3', 'Lab 3 - Deepfake Detection', '2:00', 7200),
('lab4', 'Lab 4 - Defensive Tools', '2:30', 9000),
('lab5', 'Lab 5 - OSINT Challenge', '2:40', 9600),
('quiz', 'Quiz & wrap-up', '2:50', 10200)
ON CONFLICT (id) DO NOTHING;

INSERT INTO board_items (id, text, correct, status) VALUES 
(1, 'AI-written phishing text', 'A', 'unsorted'),
(2, 'Deepfake voice cloning', 'A', 'unsorted'),
(3, 'AI-generated malware code', 'A', 'unsorted'),
(4, 'Automated vulnerability scanning', 'D', 'unsorted'),
(5, 'Anomaly / fraud scoring', 'D', 'unsorted'),
(6, 'Spam & phishing filters', 'D', 'unsorted'),
(7, 'SOC analyst copilots', 'D', 'unsorted'),
(8, 'Behavioral login detection', 'D', 'unsorted')
ON CONFLICT (id) DO NOTHING;

INSERT INTO mails (id, team_id, label, sender, body, correct, answered) VALUES 
(1, 0, 'S1', 'IT-Support@techk-nots.com', 'Urgent: Your account will be suspended in 2 hours. Verify your credentials immediately using the secure link below to avoid interruption.', 'PHISHING', false),
(2, 0, 'S2', 'placements@techknots.in', 'Hi all, attaching the confirmed schedule for next week''s VAC sessions. Let me know if your slot needs to move. No links, no attachments needed to open right away.', 'GENUINE', false),
(3, 0, 'S3', 'security-alert@paypa1-verify.com', 'Unusual sign-in detected — action required. We noticed a login from a new device. If this wasn''t you, click below within 30 minutes to secure your account before it is locked permanently.', 'PHISHING', false)
ON CONFLICT (id) DO NOTHING;

INSERT INTO clips (id, label, title, correct, explanation, answered) VALUES 
(1, 'Clip 1', 'CEO Quarterly Update Announcement', 'FAKE', 'Unnatural blinking pattern and audio artifact at 0:04.', false),
(2, 'Clip 2', 'Security Conference Keynote', 'REAL', 'Genuine footage from last year''s summit.', false)
ON CONFLICT (id) DO NOTHING;

INSERT INTO stations (id, name, url, is_active) VALUES 
(0, 'Have I Been Pwned', 'https://haveibeenpwned.com/', false),
(1, 'VirusTotal', 'https://www.virustotal.com/', false),
(2, 'Shodan (IoT Search Engine)', 'https://www.shodan.io/', false),
(3, 'CyberChef (The Cyber Swiss Army Knife)', 'https://gchq.github.io/CyberChef/', false),
(4, 'Any.Run (Interactive Malware Analysis)', 'https://any.run/', false),
(5, 'OSINT Framework', 'https://osintframework.com/', false),
(6, 'Kasm Workspaces (Browser Isolation)', 'https://kasmweb.com/', false)
ON CONFLICT (id) DO NOTHING;

INSERT INTO quiz_questions (id, text, options, answer, answered) VALUES 
(1, 'What is Prompt Injection?', '["Bypassing filters via language input", "Injecting SQL commands", "Phishing via email", "A firewall rule"]', 0, false),
(2, 'Which tool scans files for known malware signatures?', '["Have I Been Pwned", "VirusTotal", "Gandalf", "Nmap"]', 1, false),
(3, 'A common visual tell for deepfakes is:', '["High resolution", "Perfect audio sync", "Unnatural blinking/teeth", "Black and white color"]', 2, false),
(4, 'AI is most effective for defenders in:', '["Writing malware", "Pattern recognition at scale", "Social engineering", "Physical security"]', 1, false),
(5, 'The goal of Gandalf was to:', '["Guess the password", "Bypass the LLM guardrails", "Detect deepfakes", "Sort attack vs defense"]', 1, false),
(6, 'Which domain is a typo-squatting example?', '["google.com", "microsoft.com", "paypa1.com", "techknots.in"]', 2, false)
ON CONFLICT (id) DO NOTHING;

INSERT INTO osint_tasks (id, title, description, hint, correct, pts, is_active) VALUES
(1, 'Identify the Hacker''s Handle', 'Find the alias used by the author of the suspicious repository "ShadowStrike".', 'Check the commit history or author email domain.', 'cyber_phantom_99', 3, false),
(2, 'Locate the Stolen Data Server', 'An IP address was found in a pastebin dump: 198.51.100.42. Find its physical location city.', 'Use an IP Geolocation tool.', 'New York', 3, false)
ON CONFLICT (id) DO NOTHING;

INSERT INTO teaching_slides (id, title, content, is_active) VALUES
(1, 'Welcome to Cybersecurity with AI', 'Today we will explore how AI is used by both attackers and defenders. We will look at phishing, deepfakes, prompt injection, and defensive automation.', false),
(2, 'The Evolution of Phishing', 'Attackers use Large Language Models (LLMs) to generate highly convincing, personalized phishing emails at scale without spelling errors.', false),
(3, 'Prompt Injection Explained', 'Prompt injection is when a user maliciously alters the inputs to an LLM to override its original instructions and bypass safety filters.', false),
(4, 'Spotting Deepfakes', 'Look for unnatural blinking, mismatched lip-syncing, strange lighting artifacts, and robotic-sounding voice inflections.', false),
(5, 'Defensive Tools Landscape', 'Modern defenders rely on tools like Shodan, VirusTotal, and CyberChef to analyze threats and gather intelligence safely.', false)
ON CONFLICT (id) DO NOTHING;
