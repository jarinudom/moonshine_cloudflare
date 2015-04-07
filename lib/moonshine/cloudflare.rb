module Moonshine
  module Cloudflare
    # Call the recipe in your application manifest:
    #
    #  recipe :cloudflare

    def cloudflare(_options = {})
      package "apache2-threaded-dev", ensure: :installed

      # --no-check-certificate is needed because GitHub has SSL turned on all the time
      # but wget doesn't understand the wildcard SSL certificate they use (*.github.com)
      exec "install_cloudflare",
           cwd: "/tmp",
           command: [
             "wget https://raw.github.com/cloudflare/mod_cloudflare/master/mod_cloudflare.c",
             "--no-check-certificate",
             "&& apxs2 -a -i -c mod_cloudflare.c"
           ].join(" "),
           require: package("apache2-threaded-dev"),
           before: service("apache2"),
           creates: "/usr/lib/apache2/modules/mod_cloudflare.so"

      conf = <<-eos
      CloudFlareRemoteIPTrustedProxy 199.27.128.0/21
      CloudFlareRemoteIPTrustedProxy 173.245.48.0/20
      CloudFlareRemoteIPTrustedProxy 103.21.244.0/22
      CloudFlareRemoteIPTrustedProxy 103.22.200.0/22
      CloudFlareRemoteIPTrustedProxy 103.31.4.0/22
      CloudFlareRemoteIPTrustedProxy 141.101.64.0/18
      CloudFlareRemoteIPTrustedProxy 108.162.192.0/18
      CloudFlareRemoteIPTrustedProxy 190.93.240.0/20
      CloudFlareRemoteIPTrustedProxy 188.114.96.0/20
      CloudFlareRemoteIPTrustedProxy 197.234.240.0/22
      CloudFlareRemoteIPTrustedProxy 198.41.128.0/17
      CloudFlareRemoteIPTrustedProxy 162.158.0.0/15
      CloudFlareRemoteIPTrustedProxy 104.16.0.0/12
      CloudFlareRemoteIPTrustedProxy 172.64.0.0/13
      CloudFlareRemoteIPTrustedProxy 2400:cb00::/32
      CloudFlareRemoteIPTrustedProxy 2606:4700::/32
      CloudFlareRemoteIPTrustedProxy 2803:f800::/32
      CloudFlareRemoteIPTrustedProxy 2405:b500::/32
      CloudFlareRemoteIPTrustedProxy 2405:8100::/32
      eos

      file "/etc/apache2/mods-available/cloudflare.conf",
           alias: "cloudflare_conf",
           content: conf,
           mode: "644",
           notify: service("apache2")

      file "/etc/apache2/mods-available/cloudflare.load",
           alias: "load_cloudflare",
           content: "LoadModule cloudflare_module /usr/lib/apache2/modules/mod_cloudflare.so",
           mode: "644",
           require: file("cloudflare_conf"),
           notify: service("apache2")

      a2enmod "cloudflare", require: file("load_cloudflare")
    end
  end
end

