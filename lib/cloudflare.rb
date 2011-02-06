module Cloudflare

  # Call the recipe in your application manifest:
  #
  #  recipe :cloudflare
  
  def cloudflare(options = {})
    package 'apache2-threaded-dev', :ensure => :installed

    # --no-check-certificate is needed because GitHub has SSL turned on all the time
    # but wget doesn't understand the wildcard SSL certificate they use (*.github.com)
    exec 'install_cloudflare',
      :cwd => '/tmp',
      :command => [
        'wget https://github.com/cloudflare/CloudFlare-Tools/raw/master/mod_cloudflare.c --no-check-certificate',
        'apxs2 -ci mod_cloudflare.c'
      ].join(' && '),
      :require => package('apache2-threaded-dev'),
      :before => service('apache2'),
      :creates => '/usr/lib/apache2/modules/mod_cloudflare.so'

    file '/etc/apache2/mods-available/cloudflare.load',
      :alias => 'load_cloudflare',
      :content => 'LoadModule cloudflare_module /usr/lib/apache2/modules/mod_cloudflare.so',
      :mode => '644',
      :notify => service('apache2')

   a2enmod 'cloudflare', :require => file('load_cloudflare')
  end

end
