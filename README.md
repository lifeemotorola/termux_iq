# NEUROX IQ Platform - README.md

```markdown
<div align="center">

```
███╗   ██╗███████╗██╗   ██╗██████╗  ██████╗ ██╗  ██╗
████╗  ██║██╔════╝██║   ██║██╔══██╗██╔═══██╗╚██╗██╔╝
██╔██╗ ██║█████╗  ██║   ██║██████╔╝██║   ██║ ╚███╔╝ 
██║╚██╗██║██╔══╝  ██║   ██║██╔══██╗██║   ██║ ██╔██╗ 
██║ ╚████║███████╗╚██████╔╝██║  ██║╚██████╔╝██╔╝ ██╗
╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝
```

# 🧠 NEUROX — Advanced IQ Test Platform

### *The Most Feature-Rich Terminal-Based IQ Assessment Tool*

[![Platform](https://img.shields.io/badge/Platform-Termux%20%7C%20Linux%20%7C%20macOS-brightgreen?style=for-the-badge&logo=linux)](https://termux.dev)
[![Language](https://img.shields.io/badge/Language-Bash%205.0+-blue?style=for-the-badge&logo=gnu-bash)](https://www.gnu.org/software/bash/)
[![Version](https://img.shields.io/badge/Version-3.0-purple?style=for-the-badge)](https://github.com)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)](LICENSE)
[![Questions](https://img.shields.io/badge/Questions-150+-orange?style=for-the-badge)](https://github.com)
[![Categories](https://img.shields.io/badge/Categories-10-red?style=for-the-badge)](https://github.com)

---

> **"Intelligence is not just about what you know — it's about how fast**
> **and how deeply you can think."**
>
> *— NEUROX IQ Platform*

---

[🚀 Quick Start](#-quick-start) •
[✨ Features](#-features) •
[📸 Screenshots](#-screenshots) •
[🧪 Test Modes](#-test-modes) •
[📊 Scoring](#-scoring-methodology) •
[🧩 Categories](#-intelligence-categories) •
[📁 File Structure](#-file-structure) •
[🤝 Contributing](#-contributing)

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Quick Start](#-quick-start)
- [Requirements](#-requirements)
- [Installation](#-installation)
- [Features](#-features)
- [Test Modes](#-test-modes)
- [Intelligence Categories](#-intelligence-categories)
- [Scoring Methodology](#-scoring-methodology)
- [Brain Training Games](#-brain-training-games)
- [User System](#-user-system)
- [Analytics & Reports](#-analytics--reports)
- [File Structure](#-file-structure)
- [Configuration](#-configuration)
- [Screenshots](#-screenshots)
- [IQ Scale Reference](#-iq-scale-reference)
- [FAQ](#-faq)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)
- [Disclaimer](#-disclaimer)
- [License](#-license)

---

## 🌟 Overview

**NEUROX** is a comprehensive, terminal-based IQ assessment platform built entirely
in Bash shell script, designed specifically for **Termux** on Android and compatible
with any **Linux/macOS** terminal environment.

Unlike simple quiz apps, NEUROX features a **real adaptive difficulty engine**,
a **multi-factor IQ scoring algorithm**, **per-category analytics**, **user profiles**,
a **global leaderboard**, and **5 brain training mini-games** — all running beautifully
in your terminal with full color UI and animations.

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   🧠  150+ Questions across 10 Intelligence Categories      │
│   🤖  Adaptive Difficulty — adjusts to YOUR level          │
│   📊  Advanced IQ Scoring with Bell Curve Analysis          │
│   🎮  4 Test Modes + 5 Brain Training Mini-Games           │
│   👤  Full User System with Password Authentication         │
│   🏆  Global Leaderboard with Medal Rankings                │
│   📈  Detailed Per-Category Performance Analytics           │
│   💾  Persistent Score History & Data Export                │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 🚀 Quick Start

### One-Line Setup (Termux)

```bash
curl -sL https://raw.githubusercontent.com/yourrepo/neurox/main/neurox_iq.sh \
  -o neurox_iq.sh && chmod +x neurox_iq.sh && ./neurox_iq.sh
```

### Manual Setup

```bash
# Step 1: Download or create the script
nano neurox_iq.sh
# (paste the script content)

# Step 2: Make it executable
chmod +x neurox_iq.sh

# Step 3: Launch!
./neurox_iq.sh
```

---

## 📱 Requirements

### Minimum Requirements

| Component | Requirement |
|-----------|-------------|
| **Shell** | Bash 4.0+ |
| **OS** | Android (Termux), Linux, macOS |
| **Storage** | ~5 MB free space |
| **Terminal** | Any ANSI color-capable terminal |
| **RAM** | 50 MB (minimal) |

### Recommended

| Component | Recommendation |
|-----------|----------------|
| **Shell** | Bash 5.0+ |
| **Terminal** | Termux with full color support |
| **Font** | Nerd Fonts or Unicode-capable font |
| **Screen** | 80+ columns wide |
| **Tools** | `bc`, `md5sum` (optional, auto-detected) |

### Termux Specific

```bash
# Update packages first
pkg update && pkg upgrade

# Optional: Install bc for better math operations
pkg install bc

# Optional: Install coreutils for enhanced features
pkg install coreutils
```

### Check Your Bash Version

```bash
bash --version
# Should show 4.0 or higher
```

---

## 📦 Installation

### Method 1: Termux (Android) — Recommended

```bash
# 1. Open Termux
# 2. Update package list
pkg update

# 3. Ensure bash is available
pkg install bash

# 4. Create the script
mkdir -p ~/neurox && cd ~/neurox
nano neurox_iq.sh
# Paste the full script content

# 5. Set permissions
chmod +x neurox_iq.sh

# 6. Run!
./neurox_iq.sh

# Optional: Add to PATH for global access
echo 'alias neurox="~/neurox/neurox_iq.sh"' >> ~/.bashrc
source ~/.bashrc
neurox
```

### Method 2: Linux Desktop/Server

```bash
# Clone or download
wget -O neurox_iq.sh https://raw.githubusercontent.com/yourrepo/neurox/main/neurox_iq.sh

# Make executable
chmod +x neurox_iq.sh

# Run directly
./neurox_iq.sh

# Or install system-wide
sudo mv neurox_iq.sh /usr/local/bin/neurox
sudo chmod +x /usr/local/bin/neurox
neurox
```

### Method 3: macOS

```bash
# Install bash 5+ via Homebrew (macOS ships with old bash 3)
brew install bash

# Download the script
curl -O https://raw.githubusercontent.com/yourrepo/neurox/main/neurox_iq.sh
chmod +x neurox_iq.sh

# Run with bash 5+
/usr/local/bin/bash neurox_iq.sh
```

### Method 4: Git Clone

```bash
git clone https://github.com/yourrepo/neurox-iq.git
cd neurox-iq
chmod +x neurox_iq.sh
./neurox_iq.sh
```

---

## ✨ Features

### 🎯 Core Features

```
╔══════════════════════════════════════════════════════════════════╗
║  FEATURE                          DESCRIPTION                   ║
╠══════════════════════════════════════════════════════════════════╣
║  🧪 Full IQ Assessment            30 questions, all categories  ║
║  ⚡ Quick IQ Test                 15 questions, ~10 minutes     ║
║  🎯 Category Practice             Drill any specific area       ║
║  🏋️  Challenge Mode               Lives system, game-over       ║
║  🤖 Adaptive Difficulty           AI adjusts to your level      ║
║  📊 IQ Calculation Engine         Multi-factor bell curve       ║
║  📈 Category Analytics            Per-topic performance bars    ║
║  🧠 Brain Training Games          5 cognitive warm-up games     ║
║  👤 User Authentication           Register/Login with password  ║
║  🏆 Global Leaderboard            Top 10 with medal rankings    ║
║  💾 Score History                 Persistent test records       ║
║  📤 Data Export                   Save results to text file     ║
║  🎨 Full Color UI                 ANSI terminal animations      ║
║  💡 Explanations                  Every answer explained        ║
╚══════════════════════════════════════════════════════════════════╝
```

### 🎨 UI & Experience Features

- **Animated startup sequence** with loading bars
- **Typewriter text effects** for dramatic reveals
- **Animated IQ score reveal** with suspense
- **Real-time progress bars** during tests
- **Countdown timers** for challenge mode
- **Color-coded feedback** (green=correct, red=wrong, yellow=skip)
- **Streak fire indicators** (🔥) for consecutive correct answers
- **Bell curve visualization** showing where you stand
- **Category performance bars** with color coding
- **Spinning progress animations** during calculations
- **Box-drawing character UI** for professional look

### 🤖 Intelligent Features

- **Adaptive Difficulty Engine**: 10-level system that goes up on correct, down on wrong
- **Multi-Factor IQ Algorithm**: Accuracy + Speed + Streak = Final IQ
- **Weakest/Strongest Detection**: Automatically identifies your best and worst areas
- **Percentile Calculation**: Maps your IQ to population distribution
- **Personalized Recommendations**: Custom advice based on your results
- **Anti-Cheat Skip Detection**: Tracks skipped questions separately

---

## 🧪 Test Modes

### 1. 🧪 Full IQ Assessment
```
Duration:    25–35 minutes
Questions:   30 (3 per category)
Difficulty:  Adaptive
Scoring:     Full IQ calculation with all modifiers
Best for:    Serious assessment, first-time users
```
- Covers ALL 10 intelligence categories
- Shows category transition screens
- Full detailed results with bell curve
- Saves to leaderboard

### 2. ⚡ Quick IQ Test
```
Duration:    8–12 minutes
Questions:   15 (random categories)
Difficulty:  Adaptive
Scoring:     Standard IQ calculation
Best for:    Daily practice, time-limited sessions
```
- Random category selection
- Same scoring algorithm as full test
- Faster overall experience

### 3. 🎯 Category Practice
```
Duration:    Custom (1–10 questions)
Questions:   Your choice (1–10)
Difficulty:  Easy / Medium / Hard / Adaptive
Scoring:     Category-specific tracking
Best for:    Targeting weak areas
```

**Available categories:**

| # | Category | Focus Area |
|---|----------|------------|
| 1 | Pattern Recognition | Shapes, sequences, visual logic |
| 2 | Mathematical Reasoning | Word problems, probability |
| 3 | Spatial Intelligence | 3D, rotation, geometry |
| 4 | Verbal Intelligence | Analogies, vocabulary |
| 5 | Logical Deduction | Syllogisms, knights & knaves |
| 6 | Memory & Recall | Numbers, words, sequences |
| 7 | Numerical Sequences | Series completion |
| 8 | Abstract Reasoning | Symbol operations, sets |
| 9 | Processing Speed | Timed math drills |
| 10 | Lateral Thinking | Creative puzzles, riddles |

### 4. 🏋️ Challenge Mode
```
Duration:    10–20 minutes
Questions:   Up to 20
Lives:       3 ❤️❤️❤️
Difficulty:  Increases every 5 questions
Scoring:     Streak multipliers + speed bonuses
Best for:    Competitive play, skill testing
```

**Challenge Mode Rules:**
```
┌─────────────────────────────────────────────┐
│  ❤️  You start with 3 lives                 │
│  💀  Wrong answer = lose 1 life             │
│  ⚡  Difficulty increases every 5 Qs        │
│  🔥  Streak bonuses multiply your points    │
│  🏁  Survive all 20 for bonus IQ points     │
│  ☠️  0 lives = GAME OVER (results shown)    │
└─────────────────────────────────────────────┘
```

---

## 🧩 Intelligence Categories

### 1. 🔮 Pattern Recognition
Tests your ability to identify rules and predict continuations in visual and symbolic sequences.

```
Example:
  ┌──────────────────────────────────────────┐
  │  △ △ □ △ △ □ △ △  ?                    │
  │                                          │
  │  A) △    B) □    C) ○    D) ◇           │
  │                                          │
  │  Answer: B) □  (Pattern: △△□ repeating) │
  └──────────────────────────────────────────┘
```

**Question Types:**
- Shape & symbol alternation patterns
- Matrix completion puzzles
- Transformation rules
- Hidden sequence rules (months, letters)
- Advanced: Fibonacci, rotation matrices

---

### 2. 🔢 Mathematical Reasoning
Tests numerical problem-solving, not just calculation but logical math thinking.

```
Example:
  ┌──────────────────────────────────────────┐
  │  A train travels 60 km at 30 km/h, then │
  │  60 km at 60 km/h. Average speed = ?    │
  │                                          │
  │  A) 45   B) 40   C) 48   D) 36 km/h    │
  │                                          │
  │  Answer: B) 40 km/h (harmonic mean!)    │
  └──────────────────────────────────────────┘
```

**Question Types:**
- Rate & work problems
- Set theory (Venn diagrams)
- Probability & combinatorics
- Percentage & ratio problems
- Clock angle problems
- Logarithms & exponential growth

---

### 3. 🗺️ Spatial Intelligence
Tests mental visualization, 3D thinking, and spatial manipulation.

```
Example:
  ┌──────────────────────────────────────────┐
  │  A 3×3×3 cube, painted on all faces,    │
  │  cut into 27 unit cubes.                │
  │  How many have EXACTLY 2 painted faces? │
  │                                          │
  │  A) 6   B) 8   C) 12   D) 10           │
  │                                          │
  │  Answer: C) 12 (edge cubes)             │
  └──────────────────────────────────────────┘
```

**Question Types:**
- Net folding (2D → 3D)
- Mirror images & rotations
- Counting shapes in figures
- Dice face problems
- Chess board counting
- 4D hypercube concepts

---

### 4. 📚 Verbal Intelligence
Tests language comprehension, vocabulary depth, and verbal analogy reasoning.

```
Example:
  ┌──────────────────────────────────────────┐
  │  SOPORIFIC : SLEEP :: EMETIC : ?        │
  │                                          │
  │  A) Eating  B) Laughing                 │
  │  C) Vomiting D) Crying                  │
  │                                          │
  │  Answer: C) Vomiting                    │
  │  (Soporific induces sleep;              │
  │   Emetic induces vomiting)              │
  └──────────────────────────────────────────┘
```

**Question Types:**
- Synonym & antonym pairs
- Word analogies (A:B :: C:D)
- Advanced vocabulary (GRE-level)
- Anagram solving
- Compound word connections
- Palindrome identification

---

### 5. 🔍 Logical Deduction
Tests formal logic, syllogisms, truth-telling puzzles, and deductive reasoning.

```
Example:
  ┌──────────────────────────────────────────┐
  │  Knights always tell truth,              │
  │  Knaves always lie.                     │
  │  A says: "We are both Knaves."          │
  │  What are A and B?                      │
  │                                          │
  │  Answer: A=Knave, B=Knight              │
  │  (A can't be Knight—would be lying;     │
  │   A=Knave means B must be Knight)       │
  └──────────────────────────────────────────┘
```

**Question Types:**
- Categorical syllogisms
- Knights & Knaves puzzles
- Wason Selection Task
- Monty Hall Problem
- Balance scale puzzles
- Logical equivalence

---

### 6. 🧠 Memory & Recall
Tests working memory capacity through three different memory challenge types.

```
Memory Test Types:
  ┌───────────────────────────────────────────┐
  │  🔢 NUMBER RECALL                        │
  │  Memorize: 7 3 8 4 1 9 2               │
  │  (Disappears after 9 seconds)            │
  ├───────────────────────────────────────────┤
  │  📝 WORD RECALL                          │
  │  Memorize: RIVER CRYSTAL ANCHOR          │
  │  (Disappears, type all words back)       │
  ├───────────────────────────────────────────┤
  │  🧭 DIRECTION SEQUENCE                   │
  │  Memorize: ↑ ↓ → ← ↑ →                │
  │  (Type: U D R L U R)                    │
  └───────────────────────────────────────────┘
```

**Difficulty Scaling:**
- Easy: 5 digits / 4 words / 4 arrows
- Medium: 7 digits / 6 words / 6 arrows
- Hard: 10 digits / 8 words / 8 arrows

---

### 7. 🔢 Numerical Sequences
Tests your ability to find and extend mathematical patterns in number series.

```
Example:
  ┌──────────────────────────────────────────┐
  │  Complete: 2, 12, 36, 80, 150, ?        │
  │                                          │
  │  A) 246  B) 252  C) 260  D) 240         │
  │                                          │
  │  Answer: B) 252                         │
  │  Rule: n²(n+1):                         │
  │  1²×2=2, 2²×3=12, 3²×4=36,            │
  │  4²×5=80, 5²×6=150, 6²×7=252          │
  └──────────────────────────────────────────┘
```

**Question Types:**
- Arithmetic sequences
- Geometric sequences
- Fibonacci variants
- Square/cube number series
- Tetrahedral numbers
- Combined operation rules

---

### 8. 🌀 Abstract Reasoning
Tests the ability to work with abstract symbols, operations, and rule systems.

```
Example:
  ┌──────────────────────────────────────────┐
  │  Operation ⊕ defined as: a⊕b = a² - b² │
  │                                          │
  │  What is (3 ⊕ 2) ⊕ 1 ?                 │
  │                                          │
  │  A) 24  B) 4  C) 20  D) 0              │
  │                                          │
  │  Answer: A) 24                          │
  │  3⊕2 = 9-4 = 5                         │
  │  5⊕1 = 25-1 = 24                       │
  └──────────────────────────────────────────┘
```

**Question Types:**
- Custom operation definitions
- Symbol coding/decoding
- Set operations (union, intersection)
- Function composition
- Matrix pattern completion
- Conceptual categorization

---

### 9. ⚡ Processing Speed
Tests mental processing velocity through rapid-fire timed math challenges.

```
Challenge Format:
  ┌──────────────────────────────────────────┐
  │  ⏱ 3...2...1... GO!                    │
  │                                          │
  │  [1] 47 + 38 = ___                     │
  │  [2] 12 × 9  = ___                     │
  │  [3] 156 - 47 = ___                    │
  │  [4] (8 × 7) + 5 = ___                 │
  │  [5] 13² = ___                         │
  │                                          │
  │  Speed + Accuracy = Score               │
  └──────────────────────────────────────────┘
```

**Difficulty Levels:**
- Easy: 3 questions, addition/subtraction (numbers 1-20)
- Medium: 5 questions, multiplication/large addition
- Hard: 7 questions, compound operations, squares

---

### 10. 🌈 Lateral Thinking
Tests creative, unconventional problem-solving and thinking outside the box.

```
Example:
  ┌──────────────────────────────────────────┐
  │  A man is pushing his car along a road. │
  │  He comes to a hotel and shouts,        │
  │  "I'm bankrupt!"  Why?                  │
  │                                          │
  │  A) Car broke down near expensive hotel  │
  │  B) Playing Monopoly                    │
  │  C) Lost a bet                          │
  │  D) Hotel overcharged him               │
  │                                          │
  │  Answer: B) Playing Monopoly            │
  └──────────────────────────────────────────┘
```

**Question Types:**
- Classic lateral thinking puzzles
- Trick questions & misdirection
- Famous riddles (philosophical)
- Real-world paradoxes
- Observer perspective shifts

---

## 📊 Scoring Methodology

### IQ Calculation Formula

```
Final IQ = Base IQ + Speed Modifier + Streak Modifier
         = f(accuracy) + g(avg_time) + h(max_streak)
```

### Step 1: Base IQ from Accuracy

```
Accuracy → Base IQ (Bell Curve Mapping)

  95–100% → 145   (Genius territory)
  90–94%  → 138   (Very Superior)
  85–89%  → 132   (Very Superior)
  80–84%  → 126   (Superior)
  75–79%  → 120   (Superior)
  70–74%  → 115   (High Average)
  65–69%  → 110   (High Average)
  60–64%  → 105   (Average+)
  55–59%  → 100   (Average)
  50–54%  →  96   (Average)
  45–49%  →  92   (Low Average)
  40–44%  →  88   (Low Average)
  35–39%  →  84   (Below Average)
  30–34%  →  80   (Below Average)
  25–29%  →  76   (Below Average)
  Below   →  68   (Needs Improvement)
```

### Step 2: Speed Modifier

```
Average Time per Question → IQ Adjustment

  < 5 seconds   → +8 IQ points  (Lightning fast)
  5–9 seconds   → +5 IQ points  (Very fast)
  10–14 seconds → +3 IQ points  (Fast)
  15–29 seconds →  0 IQ points  (Normal)
  30–44 seconds → -2 IQ points  (Slow)
  45+ seconds   → -5 IQ points  (Very slow)
```

### Step 3: Streak Modifier

```
Maximum Consecutive Correct → IQ Adjustment

  10+ streak → +5 IQ points
  7–9 streak → +3 IQ points
  5–6 streak → +2 IQ points
  3–4 streak → +1 IQ points
  < 3 streak →  0 IQ points
```

### Points System (In-Test)

```
  ┌──────────────────────────────────────────┐
  │  BASE POINTS                            │
  │  • Correct answer:          +10 pts     │
  │                                          │
  │  SPEED BONUS                            │
  │  • Answer in < 5 seconds:   +10 pts     │
  │  • Answer in < 10 seconds:   +5 pts     │
  │                                          │
  │  STREAK BONUS                           │
  │  • 4+ consecutive correct:  +streak pts │
  │  • (e.g., 6 streak = +6)               │
  │                                          │
  │  MEMORY QUESTIONS                       │
  │  • Full number correct:   +len×2 pts    │
  │  • Each correct word:        +3 pts     │
  │                                          │
  │  PROCESSING SPEED                       │
  │  • All correct + speed bonus            │
  │  • Partial credit for partial correct   │
  └──────────────────────────────────────────┘
```

### IQ Score Clamping

```
Minimum IQ: 55  (never displays below)
Maximum IQ: 160 (never displays above)
```

---

## 🎮 Brain Training Games

### 1. 🔢 Speed Math Drill
```
Format:    20 math problems back-to-back
Types:     Addition, subtraction, multiplication
Goal:      Solve as fast + accurately as possible
Scored on: Speed + accuracy combined
```

### 2. 🔤 Word Scramble
```
Format:    5 scrambled words to unscramble
Words:     Intelligence-related (10+ letters)
Goal:      Unscramble all words correctly
Example:   TNILEGNEICLE → INTELLIGENCE
```

### 3. 🎯 Number Memory Game
```
Format:    Increasingly longer numbers
Start:     3 digits
Increases: +1 digit each correct round
Goal:      Go as long as possible
Record:    Track your personal best
```

### 4. 🧩 Pattern Match
```
Format:    Find matching pattern in 4 options
Types:     Symbol patterns (●○, ■□, ▲▼)
Rounds:    5 rounds per game
Goal:      Quick visual recognition
```

### 5. ⏱ Reaction Timer
```
Format:    Press Enter when "GO!" appears
Rounds:    5 rounds
Measure:   Millisecond reaction time
Ratings:   Lightning / Good / Keep Practicing
```

---

## 👤 User System

### Registration
```bash
# When prompted, provide:
Username:    (unique, alphanumeric)
Password:    (hidden input, confirmed twice)
Age:         (affects baseline expectations)
Education:   high_school / bachelor / master / phd
```

### Data Stored Per User

```
~/.neurox_iq/
├── users.dat         # username|password_hash|age|education|date
├── scores.dat        # user|type|iq|correct|total|score|acc|time|streak|date
├── leaderboard.dat   # user|iq|date (best scores)
├── test_log.dat      # detailed session logs
└── settings.dat      # user preferences
```

### Password Security
```
• Passwords are hashed using MD5 before storage
• Plain text passwords are NEVER stored
• Input uses hidden mode (no echo to screen)
• Password confirmation required during registration
```

### Guest Mode
```
• No registration required
• Session data not persisted between runs
• Cannot appear on leaderboard
• All test features still accessible
```

---

## 📈 Analytics & Reports

### Per-Test Report Includes

```
╔══════════════════════════════════════════════════╗
║           🧠 YOUR IQ TEST RESULTS 🧠            ║
╠══════════════════════════════════════════════════╣
║                                                  ║
║         ╔═══════════╗                            ║
║         ║  IQ: 127  ║  ← Color-coded by level   ║
║         ╚═══════════╝                            ║
║                                                  ║
║  Classification: Superior                        ║
║  Percentile: Top 95%                             ║
║                                                  ║
╠══════════════════════════════════════════════════╣
║  Test Type:    Full IQ Assessment                ║
║  Questions:    30                                ║
║  Correct:      25  (83%)                         ║
║  Wrong:        4                                 ║
║  Skipped:      1                                 ║
║  Total Score:  312 pts                           ║
║  Avg Time:     14s per question                  ║
║  Best Streak:  8 🔥                              ║
╚══════════════════════════════════════════════════╝
```

### Category Breakdown View

```
Pattern Recognition   [████████████████░░░░░░░░░] 64% (2/3)
Mathematical Reason   [█████████████████████████]100% (3/3)
Spatial Intelligence  [████████████████░░░░░░░░░] 67% (2/3)
Verbal Intelligence   [█████████████████████░░░░] 83% (5/6)
Logical Deduction     [████████████████████░░░░░] 80% (4/5)
...
```

### Bell Curve Visualization

```
Population IQ Distribution — Visual Bell Curve

         ██████
     ██████████████
  ████████████████████
██████████████████████████████████████
55-69  70-84  85-99  100-114  115-129  130-144  145+

Your range highlighted in green █
```

### Data Export

```bash
# Results saved to:
~/iq_results_USERNAME_YYYYMMDD.txt

# Contents:
=== NEUROX IQ Test Results ===
User: john_doe
Export Date: 2024-01-15 14:30:22
=========================
john_doe|Full IQ Assessment|127|25|30|312|83|14|8|2024-01-15
john_doe|Quick IQ Test|119|11|15|145|73|18|5|2024-01-16
...
```

---

## 📁 File Structure

```
neurox-iq/
│
├── neurox_iq.sh                  # 🎯 Main executable (everything in one file!)
│
├── README.md                     # 📖 This documentation
│
├── LICENSE                       # ⚖️  MIT License
│
└── ~/.neurox_iq/                 # 💾 Auto-created data directory
    │
    ├── users.dat                 # 👤 User account database
    │   └── format: user|pass_hash|age|education|created_date
    │
    ├── scores.dat                # 📊 All test results
    │   └── format: user|type|iq|correct|total|score|acc%|avg_time|streak|date
    │
    ├── leaderboard.dat           # 🏆 Best scores for ranking
    │   └── format: user|iq|date
    │
    ├── test_log.dat              # 📋 Session activity log
    │
    └── settings.dat              # ⚙️  User preferences (reserved)
```

### Script Internal Structure

```
neurox_iq.sh
│
├── CONFIGURATION & INITIALIZATION   (lines 1-50)
│   ├── Data directory setup
│   ├── Session variables
│   └── Category arrays
│
├── COLOR & STYLE DEFINITIONS        (lines 51-90)
│   ├── Foreground colors (16 types)
│   ├── Background colors
│   └── Text styles
│
├── UTILITY FUNCTIONS                (lines 91-200)
│   ├── clear_screen, press_continue
│   ├── type_text (typewriter effect)
│   ├── progress_bar, spinner
│   ├── loading_animation
│   ├── draw_box, hr (dividers)
│   └── countdown_display
│
├── BANNER & BRANDING               (lines 201-250)
│   ├── show_brain (ASCII art)
│   └── show_banner (logo)
│
├── USER MANAGEMENT                 (lines 251-350)
│   ├── user_login
│   ├── register_user
│   └── login_user
│
├── MAIN MENU                       (lines 351-400)
│
├── QUESTION DATABASES              (lines 401-1100)
│   ├── ask_pattern_recognition     (15 questions, 3 difficulties)
│   ├── ask_mathematical_reasoning  (15 questions, 3 difficulties)
│   ├── ask_spatial_intelligence    (15 questions, 3 difficulties)
│   ├── ask_verbal_intelligence     (15 questions, 3 difficulties)
│   ├── ask_logical_deduction       (15 questions, 3 difficulties)
│   ├── ask_memory_recall           (3 sub-types, 3 difficulties)
│   ├── ask_numerical_sequences     (15 questions, 3 difficulties)
│   ├── ask_abstract_reasoning      (12 questions, 3 difficulties)
│   ├── ask_processing_speed        (timed drill, 3 difficulties)
│   └── ask_lateral_thinking        (12 questions, 3 difficulties)
│
├── CORE QUESTION ENGINE            (lines 1101-1200)
│   ├── ask_question (main renderer)
│   └── adaptive difficulty tracker
│
├── IQ CALCULATION ENGINE           (lines 1201-1280)
│   ├── calculate_iq
│   ├── get_iq_classification
│   └── get_iq_percentile
│
├── RESULTS DISPLAY ENGINE          (lines 1281-1450)
│   ├── show_detailed_results
│   ├── show_category_breakdown
│   ├── show_iq_distribution
│   └── show_recommendations
│
├── TEST MODES                      (lines 1451-1650)
│   ├── reset_session
│   ├── full_iq_test
│   ├── quick_iq_test
│   ├── category_practice
│   └── challenge_mode
│
├── BRAIN TRAINING GAMES            (lines 1651-1850)
│   ├── brain_games (menu)
│   ├── speed_math_drill
│   ├── word_scramble
│   ├── number_memory_game
│   ├── pattern_match_game
│   └── reaction_timer
│
├── HISTORY & ANALYTICS             (lines 1851-1920)
│   └── view_results
│
├── LEADERBOARD                     (lines 1921-1970)
│   └── show_leaderboard
│
├── SETTINGS                        (lines 1971-2050)
│   └── settings_menu
│
├── ABOUT IQ                        (lines 2051-2100)
│   └── about_iq
│
├── EXIT                            (lines 2101-2130)
│   └── exit_program
│
└── STARTUP & LAUNCH                (lines 2131-2160)
    ├── startup
    └── main() entry point
```

---

## ⚙️ Configuration

### Adjustable Constants (Top of Script)

```bash
VERSION="3.0"                    # Platform version string

# Paths
DATA_DIR="$HOME/.neurox_iq"      # Change to move data directory
SCORES_FILE="$DATA_DIR/scores.dat"
USERS_FILE="$DATA_DIR/users.dat"
LEADERBOARD_FILE="$DATA_DIR/leaderboard.dat"

# Adaptive Difficulty (1=easiest, 10=hardest)
ADAPTIVE_LEVEL=5                 # Starting difficulty level

# IQ Clamping
MIN_IQ=55                        # Lowest displayable IQ
MAX_IQ=160                       # Highest displayable IQ
```

### Environment Variables

```bash
# Set custom data directory
export NEUROX_DATA="$HOME/custom_data_path"

# Disable colors (for plain terminals)
export NO_COLOR=1

# Set default difficulty
export NEUROX_DIFFICULTY="hard"   # easy|medium|hard
```

---

## 📸 Screenshots

### Main Menu
```
  ███╗   ██╗███████╗██╗   ██╗██████╗  ██████╗ ██╗  ██╗
  ████╗  ██║██╔════╝██║   ██║██╔══██╗██╔═══██╗╚██╗██╔╝
  ██╔██╗ ██║█████╗  ██║   ██║██████╔╝██║   ██║ ╚███╔╝
  ██║╚██╗██║██╔══╝  ██║   ██║██╔══██╗██║   ██║ ██╔██╗
  ██║ ╚████║███████╗╚██████╔╝██║  ██║╚██████╔╝██╔╝ ██╗
  ╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝

  ── Advanced Intelligence Quotient Assessment Platform v3.0 ──
  ════════════════════════════════════════════════════════

  Welcome, john_doe

  ────────────────────────────────────────────────────────
  📋 MAIN MENU

  [1]  🧪  Full IQ Assessment       (All categories, ~30 min)
  [2]  ⚡  Quick IQ Test             (15 questions, ~10 min)
  [3]  🎯  Category Practice         (Choose specific area)
  [4]  🏋️   Challenge Mode           (Timed, adaptive)
  [5]  📊  View My Results           (History & analytics)
  [6]  🏆  Leaderboard               (Top scores)
  [7]  📖  About IQ & Methodology    (Learn more)
  [8]  ⚙️   Settings                 (Customize)
  [9]  🧠  Brain Training Games      (Warm up)
  [0]  🚪  Exit

  ▸ Select option:
```

### Question Screen
```
  ╔════════════════════════════════════════════════════╗
  ║  📚 Logical Deduction                             ║
  ╠════════════════════════════════════════════════════╣
  ║ Q:8 | ✓:6 | Score:78 | Streak:3🔥 | 75%          ║
  ╚════════════════════════════════════════════════════╝

  ❓ Question:

  On an island, Knights always tell truth,
  Knaves always lie.
  A says: 'We are both Knaves.'
  What are A and B?

  ────────────────────────────────────────────────────

  A) Both Knights
  B) Both Knaves
  C) A=Knave, B=Knight
  D) A=Knight, B=Knave

  ────────────────────────────────────────────────────

  ▸ Your answer (A/B/C/D or S to skip):
```

### Results Screen
```
  ╔══════════════════════════════════════════════════════╗
  ║           🧠 YOUR IQ TEST RESULTS 🧠               ║
  ╠══════════════════════════════════════════════════════╣
  ║                                                      ║
  ║            ╔═══════════╗                            ║
  ║            ║  IQ: 127  ║                            ║
  ║            ╚═══════════╝                            ║
  ║                                                      ║
  ║  Classification: Superior                            ║
  ║  Percentile: Top 95%                                 ║
  ║                                                      ║
  ╠══════════════════════════════════════════════════════╣
  ║  Questions:     30                                   ║
  ║  Correct:       25  (83%)                            ║
  ║  Total Score:   312 pts                              ║
  ║  Best Streak:   8 🔥                                 ║
  ╚══════════════════════════════════════════════════════╝
```

---

## 📊 IQ Scale Reference

```
╔════════════════════════════════════════════════════════════════╗
║                    IQ CLASSIFICATION TABLE                    ║
╠══════════╦═══════════════════╦══════════╦═════════════════════╣
║  IQ Range ║  Classification  ║ % of Pop ║  Notable Examples   ║
╠══════════╬═══════════════════╬══════════╬═════════════════════╣
║  145–160  ║ Genius           ║  0.1%   ║ Einstein, Hawking   ║
║  130–144  ║ Very Superior    ║  2.1%   ║ Top Researchers     ║
║  120–129  ║ Superior         ║  6.7%   ║ Professors, Doctors ║
║  110–119  ║ High Average     ║  16.1%  ║ Most Professionals  ║
║   90–109  ║ Average          ║  50.0%  ║ General Population  ║
║   80–89   ║ Low Average      ║  16.1%  ║                     ║
║   70–79   ║ Below Average    ║   6.7%  ║                     ║
║   55–69   ║ Needs Support    ║   2.2%  ║                     ║
╚══════════╩═══════════════════╩══════════╩═════════════════════╝

Standard Deviation: 15 points
Population Mean: 100
```

---

## ❓ FAQ

**Q: How accurate is this IQ estimate?**
> A: NEUROX provides an *educational estimate* based on accuracy, speed, and streaks. It should not be used as a clinical measurement. For certified IQ testing, consult a licensed psychologist or use standardized tests like Mensa's supervised exam.

**Q: Can I improve my IQ score with practice?**
> A: Yes! Research shows that regular cognitive training can improve performance on IQ-type tasks. Use the Category Practice mode to target weak areas.

**Q: Why does my score vary between tests?**
> A: Factors like fatigue, focus, and random question selection cause variance. Take at least 3 tests and average the results for a more stable estimate.

**Q: Is my data stored securely?**
> A: Data is stored locally on your device only. Passwords are MD5-hashed before storage. No data is transmitted externally.

**Q: Why is the difficulty different each time?**
> A: The adaptive engine starts at level 5 (medium) and adjusts. If you consistently get questions right, it escalates. This is by design — it's more accurate.

**Q: What if my terminal shows weird characters?**
> A: Ensure your terminal supports UTF-8 and Unicode. In Termux, run `locale` and check for `UTF-8`. Set with: `export LANG=en_US.UTF-8`

**Q: Can I add my own questions?**
> A: Yes! The question database is clearly structured inside the script. Each function follows a `case` pattern — simply add new cases following the same format.

**Q: Does this work offline?**
> A: Yes, 100%. No internet connection is required after installation.

**Q: How do I reset my password?**
> A: Delete your entry from `~/.neurox_iq/users.dat` and re-register. Or ask an administrator to delete your line from the file.

**Q: What is the maximum possible IQ score?**
> A: The platform caps at 160 and floors at 55. In practice, perfect accuracy + maximum speed + longest streaks yields approximately 160.

---

## 🔧 Troubleshooting

### Problem: Script won't run

```bash
# Check bash version
bash --version
# Must be 4.0+

# Fix permissions
chmod +x neurox_iq.sh

# Run explicitly with bash
bash neurox_iq.sh
```

### Problem: Colors not showing

```bash
# Check terminal color support
echo $TERM
# Should show: xterm-256color or similar

# Force color in Termux
export TERM=xterm-256color

# Test colors
echo -e "\033[0;32mGreen\033[0m \033[0;31mRed\033[0m"
```

### Problem: Unicode/Emoji not displaying

```bash
# Set UTF-8 locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# In Termux specifically:
pkg install locales
locale-gen en_US.UTF-8
```

### Problem: `md5sum` not found (macOS)

```bash
# macOS uses md5 instead
# The script handles this, but if issues:
brew install coreutils
# or
alias md5sum='md5 -r'
```

### Problem: `bc` not installed

```bash
# Termux
pkg install bc

# Ubuntu/Debian
apt install bc

# macOS
brew install bc
```

### Problem: Data directory permission error

```bash
# Fix permissions
mkdir -p ~/.neurox_iq
chmod 755 ~/.neurox_iq
chmod 644 ~/.neurox_iq/*.dat 2>/dev/null
```

### Problem: `shuf` not available

```bash
# Termux
pkg install coreutils

# The script uses shuf for word scramble game
# Without it, that specific mini-game may not work
```

### Common Error Messages

| Error | Cause | Fix |
|-------|-------|-----|
| `syntax error near unexpected token` | Old bash version | Upgrade to bash 4+ |
| `permission denied` | No execute bit | `chmod +x neurox_iq.sh` |
| `bad array subscript` | Bash < 4 (no assoc arrays) | Upgrade bash |
| `divide by zero` | No questions answered | Answer at least 1 question |
| `command not found: md5sum` | macOS system | Install coreutils via brew |

---

## 🤝 Contributing

Contributions are **warmly welcome**! Here's how to help:

### Adding New Questions

Follow the existing pattern in any `ask_*` function:

```bash
ask_question "Category Name" \
    "Your question text here\n\n  Additional details if needed" \
    "A) First option" "B) Second option" "C) Third option" "D) Fourth option" \
    "CORRECT_LETTER" \
    "Explanation of why the answer is correct."
```

**Guidelines for new questions:**
- ✅ Must have exactly 1 unambiguously correct answer
- ✅ Provide a clear, educational explanation
- ✅ Test cognitive ability, not general knowledge
- ✅ Include questions at all 3 difficulty levels
- ✅ Avoid culturally biased content
- ❌ No trick questions without clear logic
- ❌ No politically/religiously sensitive content

### Adding New Categories

1. Create a new `ask_CATEGORY_NAME()` function
2. Add it to the `ask_from_category()` dispatcher
3. Add to the `CATEGORIES` array
4. Initialize in `CAT_CORRECT`, `CAT_TOTAL`, `CAT_TIME` arrays
5. Update the category practice menu

### Adding New Mini-Games

1. Create the game function following existing patterns
2. Add to `brain_games()` menu
3. Ensure it uses the press_continue pattern at the end

### Code Style Guide

```bash
# Function naming: snake_case
function_name() {
    local variable="value"    # Always use local for function vars
    
    # Use color variables, never hardcode escape codes
    echo -e "  ${BG}Good${N} ${BR}Bad${N}"
    
    # Always provide press_continue for screens
    press_continue
}

# Comments for sections
#━━━━━━━━━━━━━━━━━━━━━━━━━
# SECTION NAME
#━━━━━━━━━━━━━━━━━━━━━━━━━

# Inline comments
local result=$((a + b))  # Brief explanation if needed
```

### Submitting Changes

```bash
# 1. Fork the repository
# 2. Create a feature branch
git checkout -b feature/new-questions-spatial

# 3. Make your changes
# 4. Test thoroughly
./neurox_iq.sh

# 5. Submit pull request with:
#    - Description of changes
#    - Test results screenshot
#    - Question source/verification
```

---

## ⚠️ Disclaimer

```
╔══════════════════════════════════════════════════════════════════╗
║                         IMPORTANT NOTICE                        ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  NEUROX is an EDUCATIONAL and ENTERTAINMENT tool.               ║
║                                                                  ║
║  • Results are ESTIMATES, not clinical measurements              ║
║  • Real IQ requires supervised, standardized testing            ║
║  • Scores can vary based on mood, fatigue, and familiarity       ║
║  • Intelligence is multidimensional — no single score defines   ║
║    a person's capability or worth                               ║
║  • For clinical IQ assessment, consult a licensed               ║
║    psychologist or neuropsychologist                            ║
║                                                                  ║
║  The IQ scale used here follows the Wechsler standard           ║
║  (mean=100, SD=15). Question difficulty calibration is          ║
║  approximate and community-validated, not clinically normed.    ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

---

## 📜 License

```
MIT License

Copyright (c) 2024 NEUROX IQ Platform

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

<div align="center">

---

**Made with 🧠 and ❤️ for terminal enthusiasts everywhere**

*NEUROX IQ Platform v3.0 — Train your brain, one question at a time*

---

[![Termux](https://img.shields.io/badge/Built%20for-Termux-black?style=flat-square&logo=android)](https://termux.dev)
[![Bash](https://img.shields.io/badge/Pure-Bash-green?style=flat-square&logo=gnu-bash)](https://www.gnu.org/software/bash/)
[![No Dependencies](https://img.shields.io/badge/Dependencies-Zero-blue?style=flat-square)](https://github.com)
[![Offline](https://img.shields.io/badge/Works-Offline-orange?style=flat-square)](https://github.com)

```
  Keep training. Keep growing. 🧠✨
```

</div>
```

---

## 📌 Quick Reference Card

Save this for easy reference:

```bash
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# NEUROX IQ PLATFORM — QUICK REFERENCE
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Install & Run
chmod +x neurox_iq.sh && ./neurox_iq.sh

# Data Location
ls ~/.neurox_iq/

# View Scores Manually
cat ~/.neurox_iq/scores.dat

# View Leaderboard Manually
sort -t'|' -k2 -rn ~/.neurox_iq/leaderboard.dat | head -10

# Export Results
grep "^USERNAME|" ~/.neurox_iq/scores.dat > my_iq_results.txt

# Reset Everything
rm -rf ~/.neurox_iq/

# Run with specific bash
/usr/local/bin/bash neurox_iq.sh   # macOS with brew bash
bash-5.0 neurox_iq.sh              # explicit bash 5
```
