#
# Cookbook Name:: nginx
# Recipe:: redis
#
# Author:: Liam Oehlman (<liam@kondoot.com>)
#
# Copyright 2012, Liam Oehlman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Recipe based on the naxsi_module.rb by Artiom Lunev

redis2_src_filename = ::File.basename(node['nginx']['redis2']['url'])
redis2_src_filepath = "#{Chef::Config['file_cache_path']}/#{redis2_src_filename}"
redis2_extract_path = "#{Chef::Config['file_cache_path']}/redis2-nginx-module-#{node['nginx']['redis2']['version']}"

cookbook_file redis2_src_filepath do
  source node['nginx']['redis2']['url']
  owner "root"
  group "root"
  mode 0644
end

bash "extract_redis2_module" do
  cwd ::File.dirname(redis2_src_filepath)
  code <<-EOH
    tar xzf #{redis2_src_filename}
  EOH

  not_if { ::File.exists?(redis2_extract_path) }
end

node.run_state['nginx_configure_flags'] =
  ["--add-module=#{redis2_extract_path}/redis2-#{node['nginx']['redis2']['version']}"] | node.run_state['nginx_configure_flags']
