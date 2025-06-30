require "../spec_helper"

# Create a wrapper class for testing since Spectator can't mock modules
class ScreenWrapper
  def self.size
    Term::Screen.size
  end
end

Spectator.describe Term::Screen do
  describe "#width, #height" do
    it "calculates screen width" do
      # Since we can't mock the module directly, we'll test the actual values
      # ensuring they return reasonable terminal dimensions
      width = Term::Screen.width
      expect(width).to be > 0
    end

    it "aliases width to columns" do
      expect(Term::Screen.columns).to eq(Term::Screen.width)
    end

    it "aliases width to cols" do
      expect(Term::Screen.cols).to eq(Term::Screen.width)
    end

    it "calculates screen height" do
      height = Term::Screen.height
      expect(height).to be > 0
    end

    it "aliases height to rows" do
      expect(Term::Screen.rows).to eq(Term::Screen.height)
    end

    it "aliases height to lines" do
      expect(Term::Screen.lines).to eq(Term::Screen.height)
    end
  end

  describe "#size_from_default" do
    it "returns default terminal size" do
      expect(Term::Screen.size_from_default).to eq({27, 80})
    end
  end

  describe "#size_from_env" do
    it "returns size from environment variables when set" do
      original_env = Term::Screen.env
      Term::Screen.env = {"LINES" => "30", "COLUMNS" => "100"}
      expect(Term::Screen.size_from_env).to eq({30, 100})
      Term::Screen.env = original_env
    end

    it "returns nil when environment variables are not set" do
      original_env = Term::Screen.env
      Term::Screen.env = {} of String => String
      expect(Term::Screen.size_from_env).to be_nil
      Term::Screen.env = original_env
    end

    it "returns nil when environment variables are invalid" do
      original_env = Term::Screen.env
      Term::Screen.env = {"LINES" => "abc", "COLUMNS" => "100"}
      expect(Term::Screen.size_from_env).to be_nil
      Term::Screen.env = original_env
    end
  end
end
