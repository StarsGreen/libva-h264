/* Copyright (c) 2016 Intel Corporation. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or
 * without modification, are permitted provided that the following
 * conditions are met:
 *
 * 1. Redistributions of source code must retain the above
 * copyright notice, this list of conditions and the following
 * disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above
 * copyright notice, this list of conditions and the following
 * disclaimer in the documentation and/or other materials provided
 * with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of
 * its contributors may be used to endorse or promote products
 * derived from this software without specific prior written
 * permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 * CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

namespace GVaH264 {

public class AU : Object {

public VaH264.buffer_create_info *au;
public size_t len;

public AU (VaH264.buffer_create_info *_au, size_t _len)
{
  au = _au;
  len = _len;
}

~AU ()
{
  VaH264.parser_free_au (au);
}

public Va.PictureParameterBufferH264*
pic_param ()
{
  for (var a = au; a < au + len; a++)
    if (a.type == Va.BufferType.PICTURE_PARAMETER)
      return a.data;
  return null;
}

public Va.SliceParameterBufferH264*
slice_param (int index)
{
  for (var a = au; a < au + len; a++)
    if (a.type == Va.BufferType.SLICE_PARAMETER) {
      if (index >= a.num_elements)
        return null;
      Va.SliceParameterBufferH264 *slice = a.data;
      return slice + index;
    }
  return null;
}

public GVa.Buffer[]
make_buffers (GVa.Context context)
{
  GVa.Buffer[] list = {};
  for (var a = au; a < au + len; a++)
    list += context.create_buffer (a.type, a.size, a.num_elements, a.data);
  return list;
}

}

}
