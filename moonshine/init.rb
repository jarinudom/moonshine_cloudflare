require "pathname"
$LOAD_PATH.unshift Pathname.new(__FILE__).dirname.join("..", "lib").expand_path
require "moonshine/cloudflare"

include Moonshine::Cloudflare

