class MainScene extends Phaser.Scene {
  constructor() {
    super('MainScene');
    this.roundIndex = 0;
    this.score = 0;
    this.selectedTask = null;
    this.selectedMethod = null;
    this.taskButtons = [];
    this.methodButtons = [];
  }

  create() {
    this.taskOptions = ['Classification', 'Regression', 'Clustering', 'Dimensionality Reduction'];
    this.methodOptions = ['Logistic Regression', 'Linear Regression', 'Decision Tree', 'Random Forest', 'k-NN', 'k-Means', 'PCA'];
    this.methodFamilies = {
      'Logistic Regression': 'usually predicts categories/classes, often as a simple linear classifier.',
      'Linear Regression': 'predicts continuous numbers and assumes a mostly linear relationship.',
      'Decision Tree': 'can handle classification or regression, but a single tree can overfit.',
      'Random Forest': 'can handle classification or regression and is often strong on tabular nonlinear data.',
      'k-NN': 'can handle classification or regression by comparing similar examples, but depends on scaling and feature quality.',
      'k-Means': 'clusters unlabeled data into groups; it does not use target labels.',
      'PCA': 'reduces many features into fewer components; it is usually preprocessing, not prediction.'
    };

    this.add.rectangle(600, 430, 1200, 860, 0x111827);
    this.add.text(40, 24, 'ML Machine Repair', {
      fontFamily: 'Arial', fontSize: '34px', color: '#f9fafb', fontStyle: 'bold'
    });
    this.add.text(40, 66, 'Install a task core and a strong starting method. The clues matter more than the story text.', {
      fontFamily: 'Arial', fontSize: '18px', color: '#cbd5e1'
    });

    this.add.rectangle(360, 275, 640, 350, 0x1f2937).setStrokeStyle(3, 0x60a5fa);
    this.add.text(70, 125, 'Machine diagnostic report', {
      fontFamily: 'Arial', fontSize: '22px', color: '#bfdbfe', fontStyle: 'bold'
    });

    this.nameText = this.add.text(75, 162, '', {
      fontFamily: 'Arial', fontSize: '23px', color: '#f8fafc', fontStyle: 'bold', wordWrap: { width: 570 }
    });
    this.symptomText = this.add.text(75, 212, '', {
      fontFamily: 'Arial', fontSize: '17px', color: '#e5e7eb', wordWrap: { width: 570 }, lineSpacing: 4
    });
    this.clueText = this.add.text(75, 375, '', {
      fontFamily: 'Arial', fontSize: '16px', color: '#fde68a', wordWrap: { width: 570 }, lineSpacing: 4
    });

    this.add.text(720, 120, '1. Task core', {
      fontFamily: 'Arial', fontSize: '22px', color: '#bfdbfe', fontStyle: 'bold'
    });
    this.add.text(720, 318, '2. Method module', {
      fontFamily: 'Arial', fontSize: '22px', color: '#bfdbfe', fontStyle: 'bold'
    });

    this.createButtons();

    this.submitButton = this.makeButton(910, 710, 330, 54, 'Run Repair Test', 0x16a34a, () => this.submitAnswer());
    this.nextButton = this.makeButton(910, 780, 330, 48, 'Next Machine', 0x2563eb, () => this.nextRound()).setVisible(false);

    this.add.rectangle(360, 665, 640, 330, 0x0f172a).setStrokeStyle(2, 0x475569);
    this.add.text(70, 515, 'Repair analysis', {
      fontFamily: 'Arial', fontSize: '22px', color: '#bfdbfe', fontStyle: 'bold'
    });
    this.feedbackText = this.add.text(75, 555, '', {
      fontFamily: 'Arial', fontSize: '16px', color: '#e2e8f0', wordWrap: { width: 570 }, lineSpacing: 4
    });
    this.progressText = this.add.text(940, 32, '', {
      fontFamily: 'Arial', fontSize: '20px', color: '#f8fafc'
    }).setOrigin(0.5, 0);

    this.loadRound();
  }

  createButtons() {
    this.taskButtons.forEach(button => button.destroy());
    this.methodButtons.forEach(button => button.destroy());
    this.taskButtons = [];
    this.methodButtons = [];

    this.taskOptions.forEach((label, index) => {
      const x = index % 2 === 0 ? 825 : 1010;
      const y = 168 + Math.floor(index / 2) * 70;
      const button = this.makeButton(x, y, 172, 52, label, 0x374151, () => {
        this.selectedTask = label;
        this.updateButtonStyles();
      });
      this.taskButtons.push(button);
    });

    this.methodOptions.forEach((label, index) => {
      const x = index % 2 === 0 ? 825 : 1010;
      const y = 365 + Math.floor(index / 2) * 58;
      const button = this.makeButton(x, y, 172, 44, label, 0x374151, () => {
        this.selectedMethod = label;
        this.updateButtonStyles();
      });
      this.methodButtons.push(button);
    });
  }

  makeButton(x, y, width, height, label, color, onClick) {
    const rect = this.add.rectangle(x, y, width, height, color).setStrokeStyle(2, 0x94a3b8).setInteractive({ useHandCursor: true });
    const text = this.add.text(x, y, label, {
      fontFamily: 'Arial', fontSize: label.length > 20 ? '13px' : '15px', color: '#f8fafc', align: 'center', wordWrap: { width: width - 16 }
    }).setOrigin(0.5);

    rect.on('pointerover', () => rect.setFillStyle(0x4b5563));
    rect.on('pointerout', () => this.updateButtonStyles());
    rect.on('pointerdown', onClick);

    const button = {
      rect,
      text,
      label,
      setVisible: visible => {
        rect.setVisible(visible);
        text.setVisible(visible);
        return button;
      },
      destroy: () => {
        rect.destroy();
        text.destroy();
      }
    };
    return button;
  }

  loadRound() {
    this.current = window.SCENARIOS[this.roundIndex];
    this.selectedTask = null;
    this.selectedMethod = null;
    this.nameText.setText(this.current.name);
    this.symptomText.setText(this.current.symptom);
    this.clueText.setText('Key evidence:\n• ' + this.current.clues.join('\n• '));
    this.feedbackText.setText('Read the evidence, then choose the task and method. You can earn partial credit: 1 point for the task, 2 for the strongest method, 1 for a reasonable-but-weaker method.');
    this.progressText.setText(`Machine ${this.roundIndex + 1}/${window.SCENARIOS.length}    Score: ${this.score}`);
    this.nextButton.setVisible(false);
    this.submitButton.setVisible(true);
    this.updateButtonStyles();
  }

  updateButtonStyles() {
    this.taskButtons.forEach(button => {
      button.rect.setFillStyle(button.label === this.selectedTask ? 0x1d4ed8 : 0x374151);
    });
    this.methodButtons.forEach(button => {
      button.rect.setFillStyle(button.label === this.selectedMethod ? 0x1d4ed8 : 0x374151);
    });
  }

  submitAnswer() {
    if (!this.selectedTask || !this.selectedMethod) {
      this.feedbackText.setText('The machine still has empty sockets. Pick both a task core and a method module.');
      return;
    }

    const taskCorrect = this.selectedTask === this.current.task;
    const methodBest = this.selectedMethod === this.current.bestMethod;
    const methodAcceptable = this.current.acceptableMethods.includes(this.selectedMethod);

    let points = 0;
    if (taskCorrect) points += 1;
    if (methodBest) points += 2;
    else if (methodAcceptable) points += 1;
    this.score += points;

    const status = this.getStatus(taskCorrect, methodBest, methodAcceptable, points);
    const taskFeedback = taskCorrect
      ? `Task: correct. ${this.current.taskReason || this.current.explanation}`
      : `Task: ${this.selectedTask} does not fit. The key clue points to ${this.current.task}: ${this.current.taskReason || this.current.explanation}`;
    const methodFeedback = this.getMethodFeedback(methodBest, methodAcceptable);

    this.feedbackText.setText(`${status}\n\n${taskFeedback}\n\n${methodFeedback}`);
    this.progressText.setText(`Machine ${this.roundIndex + 1}/${window.SCENARIOS.length}    Score: ${this.score}`);
    this.submitButton.setVisible(false);
    this.nextButton.setVisible(true);
  }

  getStatus(taskCorrect, methodBest, methodAcceptable, points) {
    if (taskCorrect && methodBest) return `Full repair! +${points}`;
    if (taskCorrect && methodAcceptable) return `Stable repair, but not the strongest module. +${points}`;
    if (taskCorrect) return `Partial repair: task is right, method is weak. +${points}`;
    if (methodBest) return `Mixed repair: method is strong, but task diagnosis is wrong. +${points}`;
    return `Repair failed. +${points}`;
  }

  getMethodFeedback(methodBest, methodAcceptable) {
    if (methodBest) {
      return `Method: correct. ${this.current.bestMethod} is the strongest starting point here because ${this.current.bestReason || this.current.explanation}`;
    }

    if (methodAcceptable) {
      const note = this.current.methodNotes[this.selectedMethod] || this.methodFamilies[this.selectedMethod];
      return `Method: reasonable, but weaker. ${this.selectedMethod} is ${note} Stronger starting point: ${this.current.bestMethod}.`;
    }

    return `Method: weak fit. ${this.selectedMethod} ${this.methodFamilies[this.selectedMethod]} In this machine, the stronger starting point is ${this.current.bestMethod}: ${this.current.bestReason || this.current.explanation}`;
  }

  nextRound() {
    this.roundIndex += 1;
    if (this.roundIndex >= window.SCENARIOS.length) {
      this.showEndScreen();
    } else {
      this.loadRound();
    }
  }

  showEndScreen() {
    const maxScore = window.SCENARIOS.length * 3;
    this.children.removeAll();
    this.add.rectangle(600, 430, 1200, 860, 0x111827);
    this.add.text(600, 120, 'Workshop Stabilized', {
      fontFamily: 'Arial', fontSize: '44px', color: '#f8fafc', fontStyle: 'bold'
    }).setOrigin(0.5);
    this.add.text(600, 190, `Final score: ${this.score}/${maxScore}`, {
      fontFamily: 'Arial', fontSize: '28px', color: '#fde68a'
    }).setOrigin(0.5);
    this.add.text(600, 270, 'What you practiced:', {
      fontFamily: 'Arial', fontSize: '24px', color: '#bfdbfe', fontStyle: 'bold'
    }).setOrigin(0.5);
    this.add.text(600, 350,
      '• Labels + category target → classification\n• Labels + numeric target → regression\n• No labels + discover groups → clustering\n• Many features + compression goal → dimensionality reduction\n• Method choice depends on likely predictive strength, not just whether it can technically run', {
      fontFamily: 'Arial', fontSize: '21px', color: '#e5e7eb', align: 'center', wordWrap: { width: 820 }, lineSpacing: 9
    }).setOrigin(0.5);

    this.makeButton(600, 600, 260, 58, 'Replay Workshop', 0x2563eb, () => {
      this.roundIndex = 0;
      this.score = 0;
      this.scene.restart();
    });
  }
}
