# encoding: utf-8

require 'rubygems'
require 'net/http'
require 'nokogiri'
require 'open-uri'
require 'rainbow'

class RKlass

  KLASSES = [
    "ARGF", "ArgumentError", "Array", "BasicObject", "Bignum", "Binding", "Class", "Comparable", 
    "Complex", "Continuation", "Data", "Dir", "EOFError", "Encoding", "Encoding/Converter", "Encoding/ConverterNotFoundError", 
    "Encoding/InvalidByteSequenceError", "Encoding/UndefinedConversionError", "EncodingError", "Enumerable", 
    "Enumerator", "Enumerator/Generator", "Enumerator/Yielder", "Errno", "Exception", "FalseClass", "Fiber", 
    "FiberError", "File", "File/Constants", "File/Stat", "FileTest", "Fixnum", "Float", "FloatDomainError", 
    "GC", "GC/Profiler", "Hash", "IO", "IO/WaitReadable", "IO/WaitWritable", "IOError", "IndexError", "Integer", 
    "Interrupt", "Kernel", "KeyError", "LoadError", "LocalJumpError", "Marshal", "MatchData", "Math", "Math/DomainError", "Method", 
    "Module", "Mutex", "NameError", "NameError/message", "NilClass", "NoMemoryError", "NoMethodError", "NotImplementedError", 
    "Numeric", "Object", "ObjectSpace", "Proc", "Process", "Process/GID", "Process/Status", "Process/Sys", 
    "Process/UID", "Random", "Range", "RangeError", "Rational", "Regexp", "RegexpError", "RubyVM", "RubyVM/Env", 
    "RuntimeError", "ScriptError", "SecurityError", "Signal", "Signal", "SignalException", "StandardError", 
    "StopIteration", "String", "Struct", "Symbol", "SyntaxError", "SystemCallError", "SystemExit", "SystemStackError", 
    "Thread", "ThreadError", "ThreadGroup", "Time", "TrueClass", "TypeError", "UnboundMethod", "ZeroDivisionError", "fatal"
  ]

  class Formatter

    class << self

      def cout(data)
        format_branch(data).join("\n")
      end

      def inherit(str)
        "    #{str}"
      end

      def point(str)
        "#{'•'.color(:red)} #{str.color(:cyan)}"
      end

      def format_branch(branch)
        lines = []
        if branch.is_a? Hash
          branch.each_pair do |k, v|
            lines << k.to_s.color(:magenta)
            format_branch(v).each do |l|
              lines << inherit(l)
            end
          end
        elsif branch.is_a? Array
          branch.each do |e|
            lines << point(e)
          end
        else
          lines << branch
        end
        lines
      end

    end
  end

  def initialize(data)
      @search = data.first
      raise "No class entry found: #{@search}." if (
        !KLASSES.include?(@search) && 
        !KLASSES.include?(@search.capitalize) && 
        !self.respond_to?(@search.to_sym)
      )
      @method = data[1] if data.size > 1
  end

  def self.load_class_data(klass)
    data = Nokogiri::HTML(open("http://ruby-doc.org/core/classes/#{klass}.html"))
    yield data if block_given?
    data
  end

  def self.parse_class_data(doc)
    methods = {}
    includes = []
    doc.css('#method-list div.name-list a').each do |method_link|
      method_name = method_link.content.to_s
      href = method_link['href'].sub('#', '')
      method_heading = ''
      method_descr = ''
      method_examples = ''
      doc.css('#method-' + href).each do |l|
        l.css('div.method-heading span.method-name').each do |span|
          method_heading = span.content.to_s.split(/<br>|\n/)
        end
        l.css('div.method-description p, div.method-description pre').each do |p|
          method_descr += p.content.to_s.gsub(/<.+?>(.+)?<\/.+?>/, '\1')
        end
      end
      methods[method_name] = {
        :interface => method_heading,
        :description => method_descr
      }
    end
    doc.css('#includes-list a').each do |incl|
      includes << incl.content.to_s
    end
    data = { :methods => methods, :includes => includes }
    yield data if block_given?
    data
  end

  def cout(&blk)
    if self.respond_to?(@search.to_sym)
      Formatter.cout(self.send(@search.to_sym, &blk))
    else
      klass = @search
      klass = klass.capitalize if !KLASSES.include?(klass)
      # class_data = parse_class_data(load_class_data(klass))
      RKlass::load_class_data(klass) do |klass_doc|
        RKlass::parse_class_data(klass_doc) do |class_data|
          data = {}
          if (@method.nil?)
            data[:methods] = class_data[:methods].keys if class_data[:methods].size > 0
            data[:includes] = class_data[:includes] if class_data[:includes].size > 0
          else
            raise "No method named '#{@method}' found for class #{klass}." if class_data[:methods][@method].nil?
            data[:method] = @method
            [:interface, :description].each do |sub|
              data[sub] = class_data[:methods][@method][sub]
            end
          end

          yield Formatter.cout({ klass => data }) if block_given?
        end
      end
    end
  end

  def list
    { :available_classes => KLASSES }
  end

  def tutorial(&blk)
    klass = KLASSES[Random.new.rand(KLASSES.size)]
    RKlass::load_class_data(klass) do |klass_doc|
      RKlass::parse_class_data(klass_doc) do |klass_data|
        data = {}
        if klass_data[:methods].any?
          method = klass_data[:methods].keys[Random.new.rand(klass_data[:methods].keys.size)]
          method_data = klass_data[:methods][method]
          data[:method] = method
          [:interface, :description].each do |sub|
            data[sub] = method_data[sub]
          end

          yield Formatter.cout({ 'Tutorial mode' => ['on'], klass => data }) if block_given?
        else
          self.tutorial(&blk)
        end
      end
    end
  end
end
