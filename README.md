RD cli tool
===========

The rd is tiny cli tool for ruby 1.9 kernel classes documenation.

Uses http://ruby-doc.org/ as data source.

Usage
-----

    $ rd list
        Will output all the kernel classes data retrieving is available for.

    $ rd :class_name
        Will output all the class methods and class includes such as additional modules.
        Example:
            $ rd exception
            will output:
                Exception
                    methods
                        • ==
                        • backtrace
                        • exception
                        • inspect
                        • message
                        • new
                        • set_backtrace
                        • to_s
            
    $ rd :class_name :method
        Will output method interface definition and method description (if available).
        Example:
            $ rd exception to_s
            will output:
                Exception
                    method
                        to_s
                    interface
                        • exception.to_s   →  string
                    description

                Returns exception‘s message (or the name of the exception if no message is set).
