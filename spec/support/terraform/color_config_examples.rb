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

require 'terraform/color_config'

RSpec.shared_examples Terraform::ColorConfig do
  describe '#coerce_color(value:)' do
    let(:call_method) { described_instance.coerce_color value: value }

    context 'when the value can be coerced to be a boolean' do
      let(:value) { true }

      before { call_method }

      subject { described_instance[:color] }

      it('updates the config assignment') { is_expected.to eq value }
    end

    context 'when the value can not be coerced to be a boolean' do
      let(:value) { 'a' }

      after { call_method }

      subject { described_instance }

      it 'an error is reported' do
        is_expected.to receive(:config_error).with attribute: 'color',
                                                   expected: 'a boolean'
      end
    end
  end

  describe '#finalize_config!(instance)' do
    include_context 'finalize_config! instance'

    describe '[:color]' do
      subject { described_instance[:color] }

      it('defaults to true') { is_expected.to eq true }
    end
  end
end
