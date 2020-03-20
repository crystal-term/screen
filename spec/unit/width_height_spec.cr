require "../spec_helper"

Spectator.describe Term::Screen do
  describe "#width, #height" do
    mock Term::Screen do;
      stub size { { 51, 280 } }
    end

    it "calcualtes screen width" do
      allow(Term::Screen).to receive(:size).and_return({ 51, 280 })
      expect(Term::Screen.width).to eq(280)
    end

    it "aliases width to columns" do
      allow(Term::Screen).to receive(:size).and_return({ 51, 280 })
      expect(Term::Screen.columns).to eq(280)
    end

    it "aliases width to cols" do
      allow(Term::Screen).to receive(:size).and_return({ 51, 280 })
      expect(Term::Screen.cols).to eq(280)
    end

    it "calcualtes screen height" do
      allow(Term::Screen).to receive(:size).and_return({ 51, 280 })
      expect(Term::Screen.height).to eq(51)
    end

    it "aliases height to rows" do
      allow(Term::Screen).to receive(:size).and_return({51, 280})
      expect(Term::Screen.rows).to eq(51)
    end

    it "aliases height to lines" do
      allow(Term::Screen).to receive(:size).and_return({51, 280})
      expect(Term::Screen.lines).to eq(51)
    end
  end
end
