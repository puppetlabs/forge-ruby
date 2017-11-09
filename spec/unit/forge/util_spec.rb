require 'puppet_forge/util'

describe PuppetForge::Util do

  describe "version_valid?" do
    it "returns true for a valid version" do
      expect(described_class.version_valid?('1.0.0')).to equal(true)
    end


    it "returns false for an invalid version" do
      expect(described_class.version_valid?('notaversion')).to equal(false)
    end

  end

end
