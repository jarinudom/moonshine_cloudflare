require File.join(File.dirname(__FILE__), "spec_helper.rb")

class CloudflareManifest < Moonshine::Manifest
  include Moonshine::Cloudflare
  configure user: "rails"
end

describe "A manifest with the Cloudflare plugin" do
  before do
    @manifest = CloudflareManifest.new
  end

  it "is executable" do
    expect(@manifest).to be_executable
  end

  describe "using the `cloudflare` recipe" do
    before do
      @manifest.cloudflare
    end

    it "ensures apache is installed" do
      expect(@manifest).to have_package("apache2-threaded-dev")
    end

    it "installs cloudflare" do
      expect(@manifest).to have_file("/usr/lib/apache2/modules/mod_cloudflare.so")
    end
  end

  # it "should provide packages/services/files" do
  #  @manifest.packages.keys.should include 'foo'
  #  @manifest.files['/etc/foo.conf'].content.should match /foo=true/
  #  @manifest.execs['newaliases'].refreshonly.should be_true
  # end
end

