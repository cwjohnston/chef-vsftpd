actions :add, :remove

attribute :username,  :kind_of => String,  :name_attribute => true
attribute :password,  :kind_of => String,  :required => true
attribute :root,      :kind_of => String,  :required => true

def initialize(*args)
  super
  @action = :add
end
