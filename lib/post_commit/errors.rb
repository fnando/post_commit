module PostCommit
  class InvalidOptionError < StandardError; end
  class AbstractMethodError < StandardError; end
  class UnknownHookError < StandardError; end
end