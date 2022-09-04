//
//  UZKFileInfo.m
//  ZipiOs
//
//

#import "UZKFileInfo.h"
#import "unzip.h"

@interface UZKFileInfo ()

@end


@implementation UZKFileInfo

#pragma mark - Initialization


+ (instancetype)fileInfo:(unz_file_info64 *)fileInfo filename:(NSString *)filename {
    return [[UZKFileInfo alloc] initWithFileInfo:fileInfo filename:filename];
}

- (instancetype)initWithFileInfo:(unz_file_info64 *)fileInfo filename:(NSString *)filename
{
    if ((self = [super init])) {
        NSArray *paths = [filename componentsSeparatedByString: @"/"];
        _filename = paths[0];
        if (paths.count == 1) {
            _uncompressedSize = fileInfo->uncompressed_size;
            _compressedSize = fileInfo->compressed_size;
            _CRC = fileInfo->crc;
            _isEncryptedWithPassword = (fileInfo->flag & 1) != 0;
        }
        _isDirectory = [_filename hasSuffix:@"/"] | (paths.count > 1);
        
        if (_isDirectory) {
            if ([_filename hasSuffix:@"/"]) {
                _filename = [_filename substringToIndex:_filename.length - 1];
            }
        }
        
        _compressionMethod = [self readCompressionMethod:fileInfo->compression_method
                                                    flag:fileInfo->flag];
        _numberFile = 1;
    }
    return self;
}

#pragma mark - Private Methods
- (UZKCompressionMethod)readCompressionMethod:(uLong)compressionMethod
                                         flag:(uLong)flag
{
    UZKCompressionMethod level = UZKCompressionMethodNone;
    if (compressionMethod != 0) {
        switch ((flag & 0x6) / 2) {
            case 0:
                level = UZKCompressionMethodDefault;
                break;
                
            case 1:
                level = UZKCompressionMethodBest;
                break;
                
            default:
                level = UZKCompressionMethodFastest;
                break;
        }
    }
    
    return level;
}

@end
