# frozen_string_literal: true

# Copyright 2016 New Context Services, Inc.
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

require_relative 'command_with_input_file'
require_relative 'command_with_output_file'
require_relative 'detached_command'

module Terraform
  # Behaviour for a command to apply an execution plan
  module ApplyCommand
    include CommandWithInputFile

    include CommandWithOutputFile

    include DetachedCommand

    def input_file
      target
    end

    def name
      'apply'
    end

    def output_file
      options.state
    end
  end
end
