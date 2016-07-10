//
//  ViewController.m
//  imageSkew
//
//  Created by Bui Duc Khanh on 7/8/16.
//  Copyright © 2016 Bui Duc Khanh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController
{
    UIImageView *mainImg;
    UISlider *sliderTransform;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Lấy kích thước
    float w = self.view.bounds.size.width;
    float h = self.view.bounds.size.height;
    
    //Tạo slider rotation
    sliderTransform = [UISlider new];
    sliderTransform.value = 0;
    sliderTransform.frame = CGRectMake(8, h - sliderTransform.bounds.size.height - 5, w - 16, sliderTransform.bounds.size.height);
    
    [self.view addSubview:sliderTransform];
    
    
    // Tạo image
    mainImg = [UIImageView new];
    mainImg.frame = CGRectMake(8, 26, w - 16, h - 26 - (sliderTransform.bounds.size.height + 5) - 10);
    [mainImg setImage:[UIImage imageNamed:@"Main"]];
    
    [self.view addSubview:mainImg];
    
    [self setRotationAxis];
    
    // Gắn sự kiện khi thay đổi giá trị của slider
    [sliderTransform addTarget:self action:@selector(onRotation) forControlEvents:UIControlEventValueChanged];
}


// Hàm thiết lập trục xoay
- (void) setRotationAxis {
    // Gốc toạ độ nằm chính giữa layer, vị trí của nó sẽ là position.x của layer cộng thêm 1/2 width của layer. Trong bài toán này ta để img full màn hình căn đều 2 bên nên khởi tạo nó sẽ ở chính giữa màn hình
    // Ở đây ta cần nó xoay quanh trục bên viền phải nên cần tịnh tiến gốc toạ độ x thêm nửa chiều dài còn nếu xoay trục bên viền trái thì trừ đi nửa chiều dài
    
    CGPoint position = mainImg.layer.position; // position cũ
    position.x += mainImg.layer.bounds.size.width / 2.0; // Tịnh tiến thêm nửa chiều dài để gốc toạ độ dịch sang viền phải
    mainImg.layer.position = position;
    
    
    
    // Image nằm trên layer vị trí của image được qui định bởi anchor point giá trị mặc định là x = 0.5, y = 0.5 tương ứng với gốc toạ độ của layer (x, y với anchor point giá trị trong khoảng từ 0 -> 1)
    // Khi x = 0 ảnh sẽ nằm lệch hẳn về bên phải gốc toạ độ khi tăng dần đến 1 nó sẽ dịch dần về bên trái đến khi = 1 thì nằm lệch hẳn về bên trái gốc toạ độ. Ở đây do dịch gốc toạ độ về viền phải nên để tạo cảm giác thị lực không đổi cần đưa ảnh dịch hẳn về bên trái tương ứng anchor point = 1
    
    // y tương tự nhưng với chiều trên xuống, trong bài này ta giữ nguyên mặc định 0.5
    
    mainImg.layer.anchorPoint = CGPointMake( 1.0, 0.5 );
}


// Hàm xoay 3D ảnh
- (void) onRotation {
    // Hàm này khởi tạo ma trận transform 4x4 bằng ma trận Identity, ma trận Identity là ma trận gốc có đường chéo chính bằng 1 các thành phần còn lại bằng 0. Và ma trận này không làm biến đổi đối tượng
    CATransform3D matrix = CATransform3DIdentity;
    
    
    // Thiết lập vị trí m34 để tạo hình chiếu phối cảnh trên trục Z tạo cảm giác 3D. Nếu để giá trị này bằng 0 ta sẽ không thấy trục Z hiệu ứng sẽ không có chiều sau. Nếu để giá trị này lớn hình chiếu trên trục Z sẽ rõ theo phương gần như vuông với màn hình dẫn đến rất khó nhìn
    // Giá trị này để âm thì khi xoay từ 0 -> pi/2 ảnh sẽ xoay theo hướng ra ngoài màn hình, còn để dương sẽ sâu vào trong. Nói chung là qui định theo chiều trục Z
    // Về bản chất khi thiết lập giá trị này ta đã biến ma trận Identity thành ma trận dạng Translation
    matrix.m34 = 0.005;
    
    
    // Hàm CATransform3DRotate sẽ tạo ra 1 ma trận rotation thực hiện xoay đối tượng 1 góc M_PI * sliderTransform.value/2.0 theo phương của vector V (0, 1, 0) dễ thấy vector này x = z = 0 và y = 1 là phương của trục OY. Sau khi tạo ra ma trận rotation nó sẽ tự nhân với matrix để kết hợp hiệu ứng translation ta gán ở trên với hiệu ứng xoay
    // Lưu ý ở đây ta chỉ xoay từ 0 -> PI/2 vì từ PI/2 -> PI nó âm sang viền phải bên ngoài màn hình và về thị giác ta không thấy gì
    matrix = CATransform3DRotate( matrix, M_PI * sliderTransform.value/2.0, 0.0, 1.0, 0.0 );
    
    
    // Đã có ma trận tạo hiệu ứng -> gán vào đối tượng để thực thi
    mainImg.layer.transform = matrix;
}

@end
