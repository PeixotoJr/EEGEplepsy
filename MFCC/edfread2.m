function [ number_of_seizures, seizure_start_time_offsets, seizure_lengths ] = edfread2( annotation_file_location )
      file_descriptor = fopen(annotation_file_location);
      byte_array = fread(file_descriptor);
      number_of_seizures = (sum(byte_array == hex2dec('ec')) - 1) / 2;
      for i=1:number_of_seizures
         seizure_start_time_offsets(i) = bin2dec(strcat(dec2bin(byte_array(23 + (i*16))),dec2bin(byte_array(26 + (i*16)))));
         seizure_lengths(i) = byte_array(34 + (i*16));
      end
end

