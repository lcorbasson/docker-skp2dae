# GPLv3
$IMPORT_FILE = "z:/home/sketchup/my_import.skp"
$EXPORT_FILE = "z:/home/sketchup/my_import.dae"

#  defines Sketchup::app_safe_shutdown method
#  by Dan Rathbun - Palm Bay, FL, USA
#  Public Domain
#  version: 1.0.0 - 27 DEC 2010
module Sketchup
  # check first if Google has added this method
  unless method_defined?( :app_safe_shutdown )
    if RUBY_PLATFORM.downcase.include?('mswin')
      # add Windows method
      def app_safe_shutdown
        send_action( 57665 ) # v7 and v8
      end # def
      module_function(:app_safe_shutdown)
    elsif RUBY_PLATFORM.downcase.include?('darwin')
      # add Mac OSX method
      def app_safe_shutdown
        # per Greg Ewing
        send_action('terminate:')
      end # def
      module_function(:app_safe_shutdown)
    else
      # Unsupported platform > silently do nothing!
    end # if
  else
    # already defined
    unless $VERBOSE.nil?
      $stderr.write('Notice: #<!: method Sketchup::app_safe_shutdown was already defined. ')
      $stderr.write("Script: '#{File.basename(__FILE__)}' did NOT redefine the method!>\n")
    end
  end # unless
end # module



 model = Sketchup.active_model
 show_summary = false # true if you want to show a summary window, false if you do not want to show a summary window

 # Import for a SKETCHUP (.skp) file
 status = model.import("#{$IMPORT_FILE}", show_summary)
 puts("Import: #{status}")

 # Export for a COLLADA (.dae) file, using the default options
 options_hash = { :triangulated_faces => true,
                  :doublesided_faces => true,
                  :edges => false,
                  :author_attribution => false,
                  :texture_maps => true,
                  :selectionset_only => false,
                  :preserve_instancing => true }
 status = model.export("#{$EXPORT_FILE}", options_hash)
 puts("Export: #{status}")

 Sketchup::app_safe_shutdown


