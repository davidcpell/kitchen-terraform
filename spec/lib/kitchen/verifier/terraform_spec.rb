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

require 'inspec'
require 'kitchen/verifier/terraform'
require 'support/terraform/client_context'
require 'support/terraform/configurable_context'
require 'support/terraform/configurable_examples'
require 'support/terraform/groups_config_examples'

::RSpec.describe ::Kitchen::Verifier::Terraform do
  include_context 'instance'

  let(:described_instance) { verifier }

  it_behaves_like ::Terraform::Configurable

  it_behaves_like ::Terraform::GroupsConfig

  describe '#call(state)' do
    include_context 'client'

    let :config do
      {
        groups: [
          {
            attributes: { attribute_name: 'attribute output name' },
            controls: ['control'], hostnames: 'hostnames output name',
            name: 'group', port: 1234, username: 'username'
          }
        ], kitchen_root: 'kitchen/root', test_base_path: 'test/base/path'
      }
    end

    let(:runner) { instance_double ::Inspec::Runner }

    let(:runner_class) { class_double(::Inspec::Runner).as_stubbed_const }

    let(:verifier) { described_class.new config }

    before do
      allow(client).to receive(:output).with(name: 'attribute output name')
        .and_return 'attribute output value'

      allow(client).to receive(:iterate_output)
        .with(name: 'hostnames output name')
        .and_yield 'a hostnames output value'

      allow(runner_class).to receive(:new).with(
        hash_including(
          attributes: { 'attribute_name' => 'attribute output value' },
          controls: ['control'], host: 'a hostnames output value',
          port: 1234, user: 'username'
        )
      ).and_return runner

      allow(runner).to receive(:run).with(no_args).and_return exit_code
    end

    subject { proc { described_instance.call({}) } }

    context 'when the Inspec Runner does return 0' do
      let(:exit_code) { 0 }

      it('does not raise an error') { is_expected.to_not raise_error }
    end

    context 'when the Inspec Runner does not return 0' do
      let(:exit_code) { 1 }

      it 'raises an ActionFailed error' do
        is_expected.to raise_error ::Kitchen::ActionFailed
      end
    end
  end
end
