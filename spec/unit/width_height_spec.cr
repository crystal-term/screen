require "../spec_helper"

# Create a wrapper class for testing since Spectator can't mock modules
class ScreenWrapper
  def self.size
    Term::Screen.size
  end
end

Spectator.describe Term::Screen do
  before_each do
    Term::Screen.invalidate_size_cache
  end

  describe "#size" do
    it "caches detected size by default" do
      original_env = Term::Screen.env
      begin
        Term::Screen.env = {"LINES" => "30", "COLUMNS" => "100"}
        first_size = Term::Screen.size

        Term::Screen.env = {"LINES" => "40", "COLUMNS" => "120"}
        expect(Term::Screen.size).to eq(first_size)
      ensure
        Term::Screen.env = original_env
        Term::Screen.invalidate_size_cache
      end
    end

    it "allows explicit cache invalidation" do
      first_size = Term::Screen.size
      Term::Screen.invalidate_size_cache

      expect(Term::Screen.size).to eq(first_size)
    end

    it "can force detection without filling the cache" do
      original_env = Term::Screen.env
      begin
        uncached_size = Term::Screen.size(cached: false)

        Term::Screen.env = {"LINES" => "40", "COLUMNS" => "120"}
        expect(Term::Screen.size).to eq(uncached_size)
      ensure
        Term::Screen.env = original_env
        Term::Screen.invalidate_size_cache
      end
    end
  end

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

  describe "#size_from_win_api" do
    {% unless flag?(:win32) || flag?(:windows) %}
      it "returns nil outside Windows" do
        expect(Term::Screen.size_from_win_api).to be_nil
      end
    {% end %}
  end

  describe "#size_from_readline" do
    {% if flag?(:without_readline) || flag?(:term_screen_no_readline) %}
      it "returns nil when readline support is disabled" do
        expect(Term::Screen.size_from_readline).to be_nil
      end
    {% end %}
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

  describe "#size_from_ansicon" do
    it "returns rows and columns from ANSICON" do
      original_env = Term::Screen.env
      begin
        Term::Screen.env = {"ANSICON" => "199x9999 (199x50)"}
        expect(Term::Screen.size_from_ansicon).to eq({50, 199})
      ensure
        Term::Screen.env = original_env
      end
    end

    it "returns nil for non-numeric ANSICON values" do
      original_env = Term::Screen.env
      begin
        Term::Screen.env = {"ANSICON" => "199x9999 (199xbad)"}
        expect(Term::Screen.size_from_ansicon).to be_nil
      ensure
        Term::Screen.env = original_env
      end
    end

    it "returns nil for malformed ANSICON values" do
      original_env = Term::Screen.env
      begin
        Term::Screen.env = {"ANSICON" => "garbage"}
        expect(Term::Screen.size_from_ansicon).to be_nil
      ensure
        Term::Screen.env = original_env
      end
    end
  end
end
