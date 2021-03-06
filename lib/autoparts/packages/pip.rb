# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

# All python packages should be rebuild on version change.
module Autoparts
  module Packages
    class Pip < Package
      name 'pip'
      version '1.5.6'
      description 'Pip: A tool for installing and managing Python packages'
      source_url 'https://pypi.python.org/packages/source/p/pip/pip-1.5.6.tar.gz'
      source_sha1 'e6cd9e6f2fd8d28c9976313632ef8aa8ac31249e'
      source_filetype 'tgz'
      category Category::DEVELOPMENT_TOOLS

      depends_on "python2"
      depends_on "setuptools"

      def compile
        Dir.chdir("pip-1.5.6") do
          args = [
            "-s", "setup.py",
            "--no-user-cfg",
            "install",
            "--force", "--verbose",
            "--prefix=#{prefix_path}",
            "--install-lib=#{python_dependency.site_packages}"
          ]

          execute python_dependency.bin_path + "python", *args
        end
      end

      def required_env
        [
          "export PATH=${PATH}:#{python_dependency.bin_path}",
        ]
      end
      
      def install
        required_files.each do |f|
          execute "mv",
            python_dependency.site_packages + f,
            prefix_path + f
        end
      end

      def post_install
        required_files.each do |f|
          execute "cp", "-rf",
            prefix_path + f,
            python_dependency.site_packages + f
        end
      end

      def python_dependency
        @python ||= get_dependency("python2")
      end

      def required_files
        [
          "easy-install.pth",
          "pip-1.5.6-py2.7.egg",
        ]
      end
    end
  end
end
