
export class QPlayerDemoSubtitleElement{

  readonly name: string;
  readonly url: string;
  readonly isSelected: boolean;

  constructor(name: string, url: string, isSelected: boolean) {
    this.name = name;
    this.url = url;
    this.isSelected = isSelected;
  }
}