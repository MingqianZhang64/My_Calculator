@Entry
@Component
struct Index {
  @State resultText: string = '0';
  private buttons: string[] = [
    '7', '8', '9', '/',
    '4', '5', '6', '*',
    '1', '2', '3', '-',
    'C', '0', '=', '+'
  ];

  build() {
    Column() {
      Column() {
        Text(this.resultText)
          .fontSize(60)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.End)
          .width('100%')
          .padding({ right: 20 })
      }
      .height('30%')
      .width('100%')
      .backgroundColor('#333333')
      .justifyContent(FlexAlign.End)
      Grid() {
        ForEach(this.buttons, (item: string) => {
          GridItem() {
            Button(item)
              .width(80)
              .height(80)
              .fontSize(30)
              .backgroundColor(this.getButtonColor(item)) // 动态设置颜色
              .fontColor(Color.White)
              .onClick(() => {
                this.onButtonClick(item);
              })
          }
        })
      }
      .columnsTemplate('1fr 1fr 1fr 1fr')
      .rowsGap(15)
      .columnsGap(15)
      .padding(20)
      .height('70%')
      .backgroundColor(Color.Black)
    }
    .height('100%')
  }

  getButtonColor(text: string): string {
    if (text === 'C') return '#FF5555';
    if (text === '=') return '#55AA55';
    if (['+', '-', '*', '/'].includes(text)) return '#FF9900'; // 运算符橙色
    return '#555555';
  }

  onButtonClick(text: string) {
    if (text === 'C') {
      this.resultText = '0';
    } else if (text === '=') {
      try {
        this.calculateResult();
      } catch (e) {
        this.resultText = 'Error';
      }
    } else {
      if (this.resultText === '0') {
        this.resultText = text;
      } else {
        this.resultText += text;
      }
    }
  }

  calculateResult() {
    let expression = this.resultText;

    const operators = ['+', '-', '*', '/'];

    let currentOp = '';
    for (let op of operators) {
      if (expression.includes(op)) {
        if (expression.indexOf(op) > 0) {
          currentOp = op;
          break;
        }
      }
    }

    if (currentOp === '') return;

    let parts = expression.split(currentOp);
    if (parts.length < 2) return;

    let num1 = parseFloat(parts[0]);
    let num2 = parseFloat(parts[1]);
    let finalResult = 0;

    switch (currentOp) {
      case '+':
        finalResult = num1 + num2;
        break;
      case '-':
        finalResult = num1 - num2;
        break;
      case '*':
        finalResult = num1 * num2;
        break;
      case '/':
        if (num2 === 0) {
          this.resultText = 'Error';
          return;
        }
        finalResult = num1 / num2;
        break;
    }
    this.resultText = finalResult.toString();
    }
  }