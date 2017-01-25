require 'formula'

class Plv8 < Formula
  desc 'V8 Engine Javascript Procedural Language add-on for PostgreSQL'
  homepage 'https://github.com/plv8/plv8'
  version '1.5.5'
  url 'https://github.com/plv8/plv8/archive/v1.5.5.tar.gz'
  sha256 '19e97ccd14343401701acacf8cfa4df457ed24de'
 
  head 'https://github.com/plv8/plv8', :using => :git
 
  depends_on 'v8' # and postgres
  depends_on :postgresql
 
  def install
    ENV.prepend 'PATH', Formula.factory('postgresql').bin, ':'
    system 'pg_config' # ensure postgres installed
    system "make"
    system "make install"
  end
 
  def test
    ENV.prepend 'PATH', Formula.factory('postgresql').bin, ':'
    system "make installcheck"
  end
end
