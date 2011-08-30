begin
  require 'RedCloth' unless defined? RedCloth
  require 'coderay' unless defined? CodeRay
rescue LoadError
  nil
end

require 'acts_as_textiled'
ActiveRecord::Base.send(:include, Err::Acts::Textiled)
