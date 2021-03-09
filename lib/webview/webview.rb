# frozen_string_literal: true

require "ffi"
require_relative "version"

class WebView
  def initialize(title: "WebView", width: 320, height: 240, debug: false)
    @title  = title
    @width  = width
    @height = height

    @handle = webview_create(debug ? 1 : 0, nil)
    ObjectSpace.define_finalizer(self, proc { webview_destroy(@handle); })

    webview_set_title(@handle, @title)
    webview_set_size(@handle, @width, @height, 0)
  end

  def navigate(page:)
    webview_navigate(@handle, page)
  end

  def run
    webview_run(@handle)
  end

  def terminate
    webview_terminate(@handle)
  end

  def bind(fn_name:, fn_proc:)
    f = FFI::Function.new(:void, [:string, :string, :pointer]) do |seq, req, arg|
      fn_proc.call(req)
    end
    webview_bind(@handle, fn_name, f, nil)
  end

  def init(js:)
    webview_init(@handle, js)
  end

  def evaluate(js:)
    webview_eval(@handle, js)
  end

  private

  extend FFI::Library
  ffi_lib ["so", "dll", "bundle"].map{|ext| File.dirname(__FILE__) + "/webview.#{ext}"}

  attach_function :webview_create,    [:int, :pointer],                        :pointer
  attach_function :webview_destroy,   [:pointer],                              :void

  attach_function :webview_set_title, [:pointer, :string],                     :void
  attach_function :webview_set_size,  [:pointer, :int, :int, :int],            :void
  attach_function :webview_navigate,  [:pointer, :string],                     :void

  attach_function :webview_init,      [:pointer, :string],                     :void
  attach_function :webview_eval,      [:pointer, :string],                     :void
  attach_function :webview_bind,      [:pointer, :string, :pointer, :pointer], :void

  attach_function :webview_run,       [:pointer],                              :void
  attach_function :webview_terminate, [:pointer],                              :void
end
