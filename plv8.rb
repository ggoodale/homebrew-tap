require 'formula'

class Plv8 < Formula
  desc 'V8 Engine Javascript Procedural Language add-on for PostgreSQL'
  homepage 'https://github.com/plv8/plv8'
  version '1.5.5'
  url 'https://github.com/plv8/plv8/archive/v1.5.5.tar.gz'
  sha256 'e043e737dd0854c88a48f59f7e8c822dea335c47e00c726c1537873da5259977'
 
  head 'https://github.com/plv8/plv8', :using => :git
 
  depends_on 'ggoodale/tap/v8@4.3.66' 
  depends_on :postgresql
 
  def install
    ENV.prepend 'PATH', Formulary.factory('postgresql').bin, ':'
    system 'pg_config' # ensure postgres installed
    system "make"
    system "make install"
  end
 
  def test
    ENV.prepend 'PATH', Formulary.factory('postgresql').bin, ':'
    system "make installcheck"
  end
end
