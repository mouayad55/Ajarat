

<?php $__env->startSection('title', 'تفاصيل المستخدم - ' . $user->name); ?>

<?php $__env->startSection('content'); ?>
<div class="row">
    <!-- بطاقة المستخدم -->
    <div class="col-lg-4 col-md-5">
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">معلومات المستخدم</h5>
            </div>
            <div class="card-body text-center">
                <!-- الصورة الشخصية للمستخدم -->
                <?php if($user->personal_photo_path): ?>
                    <?php
                        // بناء المسار الكامل للصورة الشخصية
                        $personalFullPath = base_path('public/storage/' . $user->personal_photo_path);
                        $personalActualPath = str_replace('\\', '/', $personalFullPath);
                        $personalUrl = asset('storage/' . $user->personal_photo_path);
                    ?>
                    <img src="<?php echo e($personalUrl); ?>" 
                         class="rounded-circle mb-3 border border-3 border-primary" 
                         width="150" 
                         height="150" 
                         alt="صورة المستخدم"
                         style="object-fit: cover; cursor: pointer;"
                         onclick="openLocalImage('<?php echo e($personalActualPath); ?>')"
                         onerror="this.onerror=null; this.src='https://ui-avatars.com/api/?name=<?php echo e(urlencode($user->name)); ?>&size=150&background=random';">
                <?php else: ?>
                    <img src="https://ui-avatars.com/api/?name=<?php echo e(urlencode($user->name)); ?>&size=150&background=random" 
                         class="rounded-circle mb-3 border border-3 border-secondary" 
                         width="150" 
                         height="150" 
                         alt="صورة المستخدم">
                <?php endif; ?>
                
                <h4 class="mb-1"><?php echo e($user->name); ?></h4>
                <p class="text-muted mb-3"><?php echo e($user->email); ?></p>
                
                <div class="mb-3">
                    <?php if($user->status == 'pending'): ?>
                        <span class="badge bg-warning fs-6 py-2 px-3">معلق</span>
                    <?php elseif($user->status == 'approved'): ?>
                        <span class="badge bg-success fs-6 py-2 px-3">مفعل</span>
                    <?php elseif($user->status == 'rejected'): ?>
                        <span class="badge bg-danger fs-6 py-2 px-3">مرفوض</span>
                    <?php endif; ?>
                </div>
                
                <div class="d-flex justify-content-center flex-wrap gap-2">
                    <?php if($user->status == 'pending'): ?>
                        <form action="<?php echo e(route('admin.users.approve', $user->id)); ?>" method="POST" class="d-inline">
                            <?php echo csrf_field(); ?>
                            <button type="submit" class="btn btn-success" onclick="return confirm('هل أنت متأكد من الموافقة؟')">
                                <i class="fas fa-check me-1"></i> موافقة
                            </button>
                        </form>
                        
                        <form action="<?php echo e(route('admin.users.reject', $user->id)); ?>" method="POST" class="d-inline">
                            <?php echo csrf_field(); ?>
                            <button type="submit" class="btn btn-danger" onclick="return confirm('هل أنت متأكد من الرفض؟')">
                                <i class="fas fa-times me-1"></i> رفض
                            </button>
                        </form>
                    <?php endif; ?>
                    
                    <button class="btn btn-danger" onclick="confirmDelete(<?php echo e($user->id); ?>, '<?php echo e($user->name); ?>')">
                        <i class="fas fa-trash me-1"></i> حذف
                    </button>
                </div>
                
                <!-- نموذج الحذف المخفي -->
                <form id="delete-form-<?php echo e($user->id); ?>" 
                      action="<?php echo e(route('admin.users.destroy', $user->id)); ?>" 
                      method="POST" style="display: none;">
                    <?php echo csrf_field(); ?>
                    <?php echo method_field('DELETE'); ?>
                </form>
            </div>
        </div>
        
        <!-- معلومات الاتصال -->
        <div class="card mt-3">
            <div class="card-header">
                <h5 class="mb-0">معلومات الاتصال</h5>
            </div>
            <div class="card-body">
                <ul class="list-group list-group-flush">
                    <li class="list-group-item d-flex justify-content-between align-items-center">
                        <span class="text-muted">
                            <i class="fas fa-phone text-primary me-2"></i> رقم الهاتف
                        </span>
                        <span class="fw-medium"><?php echo e($user->phone ?? 'غير متوفر'); ?></span>
                    </li>
                    <li class="list-group-item d-flex justify-content-between align-items-center">
                        <span class="text-muted">
                        </span>
                    </li>
                    <li class="list-group-item d-flex justify-content-between align-items-center">
                        <span class="text-muted">
                            <i class="fas fa-calendar text-success me-2"></i> تاريخ الميلاد
                        </span>
                        <span class="fw-medium"><?php echo e($user->birth_date ?? 'غير متوفر'); ?></span>
                    </li>
                </ul>
            </div>
        </div>
        
      
    </div>
    
    <!-- المعلومات العامة -->
    <div class="col-lg-8 col-md-7">
        <!-- المعلومات الأساسية -->
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0">التفاصيل الشخصية</h5>
                <span class="badge bg-primary">ID: <?php echo e($user->id); ?></span>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label text-muted">
                                <i class="fas fa-id-card text-secondary me-2"></i> رقم الهوية
                            </label>
                            <p class="form-control-plaintext fw-medium">
                                <?php echo e($user->national_id ?? 'غير متوفر'); ?>

                            </p>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label text-muted">
                                <i class="fas fa-user-tag text-secondary me-2"></i> نوع الحساب
                            </label>
                            <p class="form-control-plaintext fw-medium">
                                <?php if($user->type == 'admin'): ?>
                                    <span class="badge bg-danger">مسؤول</span>
                                <?php elseif($user->type == 'user'): ?>
                                    <span class="badge bg-primary">مستخدم عادي</span>
                                <?php else: ?>
                                    <span class="badge bg-secondary"><?php echo e($user->type ?? 'غير محدد'); ?></span>
                                <?php endif; ?>
                            </p>
                        </div>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label text-muted">
                                <i class="fas fa-calendar-plus text-secondary me-2"></i> تاريخ التسجيل
                            </label>
                            <p class="form-control-plaintext fw-medium">
                                <?php echo e($user->created_at->format('Y-m-d H:i')); ?>

                                <small class="text-muted">(<?php echo e($user->created_at->diffForHumans()); ?>)</small>
                            </p>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label text-muted">
                                <i class="fas fa-calendar-check text-secondary me-2"></i> آخر تحديث
                            </label>
                            <p class="form-control-plaintext fw-medium">
                                <?php echo e($user->updated_at->format('Y-m-d H:i')); ?>

                                <small class="text-muted">(<?php echo e($user->updated_at->diffForHumans()); ?>)</small>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- الصور الفعلية -->
        <div class="card mt-3">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0">
                    <i class="fas fa-images text-primary me-2"></i> الصور الفعلية المخزنة
                </h5>
                <div class="d-flex gap-2">
                    <button class="btn btn-sm btn-outline-info" onclick="checkAllImages()">
                        <i class="fas fa-sync me-1"></i> التحقق من الصور
                    </button>
                </div>
            </div>
            <div class="card-body">
                <div class="row">
                    <!-- الصورة الشخصية -->
                    <div class="col-md-6 mb-4">
                        <div class="card h-100 border">
                            <div class="card-header bg-light d-flex justify-content-between align-items-center">
                                <h6 class="mb-0">
                                    <i class="fas fa-user-circle text-primary me-2"></i>
                                    الصورة الشخصية
                                </h6>
                                <?php if($user->personal_photo_path): ?>
                                    <span class="badge bg-success">
                                        <i class="fas fa-check-circle me-1"></i> موجودة
                                    </span>
                                <?php else: ?>
                                    <span class="badge bg-danger">
                                        <i class="fas fa-times-circle me-1"></i> غير موجودة
                                    </span>
                                <?php endif; ?>
                            </div>
                            <div class="card-body">
                                <?php if($user->personal_photo_path): ?>
                                    <?php
                                        // المسار الفعلي للصورة الشخصية
                                        $personalFullPath = base_path('public/storage/' . $user->personal_photo_path);
                                        $personalActualPath = str_replace('\\', '/', $personalFullPath);
                                        $personalUrl = asset('storage/' . $user->personal_photo_path);
                                        $personalExists = file_exists($personalFullPath);
                                    ?>
                                    
                                    <div class="text-center mb-3">
                                        <?php if($personalExists): ?>
                                            <img src="<?php echo e($personalUrl); ?>" 
                                                 class="img-fluid rounded shadow-sm border"
                                                 style="max-height: 200px; width: auto; cursor: pointer;"
                                                 alt="الصورة الشخصية"
                                                 onclick="viewActualImage('<?php echo e($personalActualPath); ?>', 'صورة شخصية للمستخدم <?php echo e($user->name); ?>')"
                                                 onerror="this.onerror=null; this.src='https://ui-avatars.com/api/?name=<?php echo e(urlencode($user->name)); ?>&size=300&background=random';">
                                        <?php else: ?>
                                            <div class="alert alert-warning text-center py-4">
                                                <i class="fas fa-exclamation-triangle fa-2x mb-3"></i>
                                                <p class="mb-0">الصورة غير موجودة في المسار المحدد</p>
                                            </div>
                                        <?php endif; ?>
                                    </div>
                                    
                                    <div class="alert <?php echo e($personalExists ? 'alert-success' : 'alert-danger'); ?> py-2 mb-3">
                                        <small>
                                            <i class="fas <?php echo e($personalExists ? 'fa-check-circle' : 'fa-exclamation-triangle'); ?> me-1"></i>
                                            <strong>الحالة:</strong> 
                                            <?php if($personalExists): ?>
                                                <span class="text-success">الصورة موجودة في المسار الفعلي</span>
                                            <?php else: ?>
                                                <span class="text-danger">الصورة غير موجودة في المسار الفعلي</span>
                                            <?php endif; ?>
                                        </small>
                                    </div>
                                    
                                    <div class="d-flex justify-content-center flex-wrap gap-2 mb-3">
                                        <?php if($personalExists): ?>
                                            <button type="button" 
                                                    class="btn btn-sm btn-primary"
                                                    onclick="viewActualImage('<?php echo e($personalActualPath); ?>', 'صورة شخصية للمستخدم <?php echo e($user->name); ?>')">
                                                <i class="fas fa-eye me-1"></i> معاينة
                                            </button>
                                            
                                            <button type="button" 
                                                    class="btn btn-sm btn-success"
                                                    onclick="downloadActualImage('<?php echo e($personalActualPath); ?>', 'personal_photo_<?php echo e($user->id); ?>')">
                                                <i class="fas fa-download me-1"></i> تحميل
                                            </button>
                                        <?php endif; ?>
                                        
                                        <button type="button" 
                                                class="btn btn-sm btn-info"
                                                onclick="copyToClipboard('<?php echo e($personalActualPath); ?>')">
                                            <i class="fas fa-copy me-1"></i> نسخ المسار
                                        </button>
                                    </div>
                                    
                                   
                                <?php else: ?>
                                    <div class="text-center py-5">
                                        <i class="fas fa-user-slash fa-3x text-muted mb-3"></i>
                                        <p class="text-muted mb-0">لم يتم رفع صورة شخصية</p>
                                    </div>
                                <?php endif; ?>
                            </div>
                        </div>
                    </div>
                    
                    <!-- صورة الهوية -->
                    <div class="col-md-6 mb-4">
                        <div class="card h-100 border">
                            <div class="card-header bg-light d-flex justify-content-between align-items-center">
                                <h6 class="mb-0">
                                    <i class="fas fa-id-card text-success me-2"></i>
                                    صورة الهوية
                                </h6>
                                <?php if($user->id_photo_path): ?>
                                    <span class="badge bg-success">
                                        <i class="fas fa-check-circle me-1"></i> موجودة
                                    </span>
                                <?php else: ?>
                                    <span class="badge bg-danger">
                                        <i class="fas fa-times-circle me-1"></i> غير موجودة
                                    </span>
                                <?php endif; ?>
                            </div>
                            <div class="card-body">
                                <?php if($user->id_photo_path): ?>
                                    <?php
                                        // المسار الفعلي لصورة الهوية
                                        $idFullPath = base_path('public/storage/' . $user->id_photo_path);
                                        $idActualPath = str_replace('\\', '/', $idFullPath);
                                        $idUrl = asset('storage/' . $user->id_photo_path);
                                        $idExists = file_exists($idFullPath);
                                    ?>
                                    
                                    <div class="text-center mb-3">
                                        <?php if($idExists): ?>
                                            <img src="<?php echo e($idUrl); ?>" 
                                                 class="img-fluid rounded shadow-sm border"
                                                 style="max-height: 200px; width: auto; cursor: pointer;"
                                                 alt="صورة الهوية"
                                                 onclick="viewActualImage('<?php echo e($idActualPath); ?>', 'صورة هوية للمستخدم <?php echo e($user->name); ?>')"
                                                 onerror="this.onerror=null; this.src='<?php echo e(asset('images/id-placeholder.png')); ?>';">
                                        <?php else: ?>
                                            <div class="alert alert-warning text-center py-4">
                                                <i class="fas fa-exclamation-triangle fa-2x mb-3"></i>
                                                <p class="mb-0">صورة الهوية غير موجودة في المسار المحدد</p>
                                            </div>
                                        <?php endif; ?>
                                    </div>
                                    
                                    <div class="alert <?php echo e($idExists ? 'alert-success' : 'alert-danger'); ?> py-2 mb-3">
                                        <small>
                                            <i class="fas <?php echo e($idExists ? 'fa-check-circle' : 'fa-exclamation-triangle'); ?> me-1"></i>
                                            <strong>الحالة:</strong> 
                                            <?php if($idExists): ?>
                                                <span class="text-success">صورة الهوية موجودة في المسار الفعلي</span>
                                            <?php else: ?>
                                                <span class="text-danger">صورة الهوية غير موجودة في المسار الفعلي</span>
                                            <?php endif; ?>
                                        </small>
                                    </div>
                                    
                                    <div class="d-flex justify-content-center flex-wrap gap-2 mb-3">
                                        <?php if($idExists): ?>
                                            <button type="button" 
                                                    class="btn btn-sm btn-primary"
                                                    onclick="viewActualImage('<?php echo e($idActualPath); ?>', 'صورة هوية للمستخدم <?php echo e($user->name); ?>')">
                                                <i class="fas fa-eye me-1"></i> معاينة
                                            </button>
                                            
                                            <button type="button" 
                                                    class="btn btn-sm btn-success"
                                                    onclick="downloadActualImage('<?php echo e($idActualPath); ?>', 'id_photo_<?php echo e($user->id); ?>')">
                                                <i class="fas fa-download me-1"></i> تحميل
                                            </button>
                                        <?php endif; ?>
                                        
                                        <button type="button" 
                                                class="btn btn-sm btn-info"
                                                onclick="copyToClipboard('<?php echo e($idActualPath); ?>')">
                                            <i class="fas fa-copy me-1"></i> نسخ المسار
                                        </button>
                                    </div>
                                    
                                    
                                <?php else: ?>
                                    <div class="text-center py-5">
                                        <i class="fas fa-id-card-alt fa-3x text-muted mb-3"></i>
                                        <p class="text-muted mb-0">لم يتم رفع صورة هوية</p>
                                        <small class="text-danger">
                                            <i class="fas fa-exclamation-triangle me-1"></i>
                                            مطلوبة للتحقق من الهوية
                                        </small>
                                    </div>
                                <?php endif; ?>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- سجل النشاط -->
        <div class="card mt-3">
            <div class="card-header">
                <h5 class="mb-0">
                    <i class="fas fa-history text-secondary me-2"></i> سجل النشاط
                </h5>
            </div>
            <div class="card-body">
                <ul class="list-group list-group-flush">
                    <li class="list-group-item d-flex justify-content-between align-items-center">
                        <div>
                            <i class="fas fa-user-plus text-success me-2"></i>
                            <span>تم إنشاء الحساب</span>
                        </div>
                        <span class="text-muted"><?php echo e($user->created_at->diffForHumans()); ?></span>
                    </li>
                    
                    <?php if($user->last_login_at): ?>
                    <li class="list-group-item d-flex justify-content-between align-items-center">
                        <div>
                            <i class="fas fa-sign-in-alt text-primary me-2"></i>
                            <span>آخر تسجيل دخول</span>
                        </div>
                        <span class="text-muted">
                            <?php echo e($user->last_login_at instanceof \Carbon\Carbon ? $user->last_login_at->diffForHumans() : \Carbon\Carbon::parse($user->last_login_at)->diffForHumans()); ?>

                        </span>
                    </li>
                    <?php endif; ?>
                    
                    <?php if($user->status_updated_at): ?>
                    <li class="list-group-item d-flex justify-content-between align-items-center">
                        <div>
                            <?php if($user->status == 'approved'): ?>
                                <i class="fas fa-check-circle text-success me-2"></i>
                                <span>تم تفعيل الحساب</span>
                            <?php elseif($user->status == 'rejected'): ?>
                                <i class="fas fa-times-circle text-danger me-2"></i>
                                <span>تم رفض الحساب</span>
                            <?php endif; ?>
                        </div>
                        <span class="text-muted">
                            <?php echo e($user->status_updated_at instanceof \Carbon\Carbon ? $user->status_updated_at->diffForHumans() : \Carbon\Carbon::parse($user->status_updated_at)->diffForHumans()); ?>

                        </span>
                    </li>
                    <?php endif; ?>
                </ul>
            </div>
        </div>
    </div>
</div>

<!-- أزرار التنقل -->
<div class="row mt-4">
    <div class="col-12">
        <div class="d-flex justify-content-between">
            <a href="<?php echo e(route('admin.users.index')); ?>" class="btn btn-secondary">
                <i class="fas fa-arrow-right me-1"></i> العودة للقائمة
            </a>
            
            <div>
                <?php if($user->status == 'pending'): ?>
                <form action="<?php echo e(route('admin.users.approve', $user->id)); ?>" method="POST" class="d-inline">
                    <?php echo csrf_field(); ?>
                    <button type="submit" class="btn btn-success" onclick="return confirm('هل أنت متأكد من الموافقة على هذا المستخدم؟')">
                        <i class="fas fa-check me-1"></i> موافقة
                    </button>
                </form>
                <?php endif; ?>
                
                <button class="btn btn-danger ms-2" onclick="confirmDelete(<?php echo e($user->id); ?>, '<?php echo e($user->name); ?>')">
                    <i class="fas fa-trash me-1"></i> حذف المستخدم
                </button>
            </div>
        </div>
    </div>
</div>
<?php $__env->stopSection(); ?>

<?php $__env->startSection('scripts'); ?>
<script>
// تأكيد الحذف
function confirmDelete(userId, userName) {
    if (confirm(`هل أنت متأكد من حذف المستخدم "${userName}"؟\n\n⚠️ تحذير: هذا الإجراء لا يمكن التراجع عنه وسيتم حذف جميع بيانات المستخدم بما في ذلك الصور المرفوعة.`)) {
        document.getElementById(`delete-form-${userId}`).submit();
    }
}

// معاينة الصورة الفعلية
function viewActualImage(imagePath, title) {
    const modal = new bootstrap.Modal(document.getElementById('imagePreviewModal'));
    
    document.getElementById('imagePreviewTitle').textContent = title;
    document.getElementById('imagePreviewPath').value = imagePath;
    
    // إنشاء iframe لعرض الصورة
    const iframe = document.getElementById('imagePreviewIframe');
    iframe.srcdoc = `
        <!DOCTYPE html>
        <html dir="rtl">
        <head>
            <meta charset="UTF-8">
            <title>معاينة الصورة</title>
            <style>
                body {
                    margin: 0;
                    padding: 20px;
                    background: #f5f5f5;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    min-height: 100vh;
                }
                img {
                    max-width: 90%;
                    max-height: 90vh;
                    box-shadow: 0 4px 20px rgba(0,0,0,0.2);
                    border-radius: 8px;
                }
            </style>
        </head>
        <body>
            <img src="file:///${imagePath}" 
                 onerror="this.onerror=null; this.src='data:image/svg+xml;utf8,<svg xmlns=\'http://www.w3.org/2000/svg\' width=\'400\' height=\'300\'><rect width=\'400\' height=\'300\' fill=\'%23f8f9fa\'/><text x=\'200\' y=\'150\' text-anchor=\'middle\' font-family=\'Arial\' font-size=\'16\' fill=\'%236c757d\'>تعذر تحميل الصورة</text></svg>'">
        </body>
        </html>
    `;
    
    modal.show();
}

// تحميل الصورة الفعلية
function downloadActualImage(imagePath, filename) {
    // إنشاء رابط تحميل
    const link = document.createElement('a');
    link.href = 'file:///' + imagePath;
    link.download = filename;
    link.target = '_blank';
    
    // محاولة التحميل
    try {
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        showAlert('جاري تحميل الصورة...', 'info');
    } catch (error) {
        showAlert('تعذر تحميل الصورة. يرجى نسخ المسار وفتحه يدوياً.', 'warning');
    }
}

// نسخ النص إلى الحافظة
function copyToClipboard(text) {
    navigator.clipboard.writeText(text).then(() => {
        showAlert('تم نسخ المسار إلى الحافظة', 'success');
    }).catch(err => {
        console.error('فشل في النسخ: ', err);
        // طريقة بديلة للنسخ
        const textArea = document.createElement('textarea');
        textArea.value = text;
        document.body.appendChild(textArea);
        textArea.select();
        try {
            document.execCommand('copy');
            showAlert('تم نسخ المسار إلى الحافظة', 'success');
        } catch (err) {
            showAlert('فشل في نسخ المسار', 'danger');
        }
        document.body.removeChild(textArea);
    });
}

// نسخ المسار من حقل الإدخال
function copyPath(inputId) {
    const input = document.getElementById(inputId);
    input.select();
    input.setSelectionRange(0, 99999);
    copyToClipboard(input.value);
}

// التحقق من جميع الصور
function checkAllImages() {
    showAlert('جاري التحقق من وجود الصور...', 'info');
    
    <?php if($user->personal_photo_path): ?>
        checkImageExists('<?php echo e(base_path('public/storage/' . $user->personal_photo_path)); ?>', 'personal');
    <?php endif; ?>
    
    <?php if($user->id_photo_path): ?>
        checkImageExists('<?php echo e(base_path('public/storage/' . $user->id_photo_path)); ?>', 'id');
    <?php endif; ?>
    
    setTimeout(() => {
        location.reload();
    }, 1000);
}

// التحقق من وجود صورة
function checkImageExists(path, type) {
    fetch('<?php echo e(route("admin.users.check.image")); ?>', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-TOKEN': '<?php echo e(csrf_token()); ?>'
        },
        body: JSON.stringify({
            path: path,
            user_id: <?php echo e($user->id); ?>,
            type: type
        })
    });
}

// إظهار رسائل التنبيه
function showAlert(message, type = 'info') {
    // إزالة أي تنبيهات سابقة
    const existingAlerts = document.querySelectorAll('.custom-alert');
    existingAlerts.forEach(alert => alert.remove());
    
    const alertDiv = document.createElement('div');
    alertDiv.className = `custom-alert alert alert-${type} alert-dismissible fade show`;
    alertDiv.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        z-index: 9999;
        min-width: 300px;
        text-align: center;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    `;
    alertDiv.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    document.body.appendChild(alertDiv);
    
    // إزالة التنبيه تلقائياً بعد 3 ثواني
    setTimeout(() => {
        if (alertDiv.parentNode) {
            alertDiv.remove();
        }
    }, 3000);
}

// عند تحميل الصفحة
document.addEventListener('DOMContentLoaded', function() {
    // إضافة تأثير hover للبطاقات
    const cards = document.querySelectorAll('.card');
    cards.forEach(card => {
        card.style.transition = 'transform 0.3s, box-shadow 0.3s';
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-5px)';
            this.style.boxShadow = '0 10px 20px rgba(0,0,0,0.1)';
        });
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
            this.style.boxShadow = '';
        });
    });
});
</script>

<!-- نافذة معاينة الصورة -->
<div class="modal fade" id="imagePreviewModal" tabindex="-1">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="imagePreviewTitle">معاينة الصورة</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label">مسار الصورة:</label>
                    <div class="input-group">
                        <input type="text" class="form-control" id="imagePreviewPath" readonly>
                        <button class="btn btn-outline-secondary" type="button" onclick="copyPath('imagePreviewPath')">
                            <i class="fas fa-copy"></i>
                        </button>
                    </div>
                </div>
                <div class="border rounded" style="height: 500px;">
                    <iframe id="imagePreviewIframe" style="width: 100%; height: 100%; border: none;"></iframe>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="fas fa-times me-1"></i> إغلاق
                </button>
                <button type="button" class="btn btn-primary" onclick="printImage()">
                    <i class="fas fa-print me-1"></i> طباعة
                </button>
            </div>
        </div>
    </div>
</div>

<script>
function printImage() {
    const iframe = document.getElementById('imagePreviewIframe');
    iframe.contentWindow.print();
}

// CSS إضافي
const style = document.createElement('style');
style.textContent = `
.custom-alert {
    animation: slideInRight 0.3s ease-out;
    border-radius: 8px;
    border: none;
}

@keyframes slideInRight {
    from {
        transform: translateX(100%);
        opacity: 0;
    }
    to {
        transform: translateX(0);
        opacity: 1;
    }
}

.img-fluid {
    transition: transform 0.3s;
}

.img-fluid:hover {
    transform: scale(1.05);
}

.card {
    border-radius: 10px;
    overflow: hidden;
}

.input-group-sm input {
    font-size: 0.875rem;
}

.text-break {
    word-break: break-all;
}
`;
document.head.appendChild(style);
</script>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.admin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH C:\Develop\University\programming-language-project\resources\views/admin/users/show.blade.php ENDPATH**/ ?>