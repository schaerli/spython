# Cookbook:: spython
# Resource:: runtime
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

resource_name :spython_runtime
provides :spython_runtime
default_action :install

property :version, String, name_property: true

action :install do
  version = new_resource.version
  py = spython_attributes(version)

  py['packages'].each do |pkg|
    package pkg
  end

  execute "spython[#{version}]-pip-upgrade" do
    action :run
    command "#{node['pip'][new_resource.version.to_s]['bin']} install pip --upgrade --index-url=https://pypi.python.org/simple"
    only_if { py['pip_upgrade'] }
    ignore_failure true
  end

  execute "spython[#{version}]-setuptools-upgrade" do
    action :run
    command "#{node['pip'][new_resource.version.to_s]['bin']} install setuptools --upgrade"
    only_if { py['setuptools_upgrade'] }
    ignore_failure true
  end
end
