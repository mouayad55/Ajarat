

<?php $__env->startSection('title', 'المستخدمين المعلقين'); ?>

<?php $__env->startSection('content'); ?>
<div class="row">
    <div class="col-12">
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0">المستخدمين المعلقين للمراجعة</h5>
                <a href="<?php echo e(url('admin/users')); ?>" class="btn btn-primary">
                    <i class="fas fa-arrow-right"></i> جميع المستخدمين
                </a>
            </div>
            
            <div class="card-body">
                <?php if(session('success')): ?>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <?php echo e(session('success')); ?>

                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <?php endif; ?>
                
                <div class="row mb-4">
                    <div class="col-md-4">
                        <div class="card bg-light">
                            <div class="card-body text-center">
                                <h2 class="text-primary"><?php echo e($pendingUsers->count()); ?></h2>
                                <p class="mb-0">مستخدمين بانتظار المراجعة</p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <?php if($pendingUsers->isEmpty()): ?>
                    <div class="text-center py-5">
                        <i class="fas fa-user-check fa-3x text-success mb-3"></i>
                        <h4 class="text-success">لا يوجد مستخدمين معلقين</h4>
                        <p class="text-muted">جميع طلبات التسجيل تمت مراجعتها</p>
                    </div>
                <?php else: ?>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>البيانات الشخصية</th>
                                    <th>معلومات الاتصال</th>
                                    <th>الوثائق المرفوعة</th>
                                    <th>تاريخ التسجيل</th>
                                    <th>الإجراءات</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php $__currentLoopData = $pendingUsers; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $user): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                <tr>
                                    <td><?php echo e($loop->iteration); ?></td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <img src="<?php echo e($user->profile_image ?? 'https://ui-avatars.com/api/?name=' . urlencode($user->name) . '&background=random'); ?>" 
                                                 class="user-avatar me-3" alt="<?php echo e($user->name); ?>">
                                            <div>
                                                <strong><?php echo e($user->name); ?></strong><br>
                                                <small class="text-muted"><?php echo e($user->national_id ?? 'غير متوفر'); ?></small>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <i class="fas fa-envelope text-primary"></i> <?php echo e($user->email); ?><br>
                                        <i class="fas fa-phone text-secondary"></i> <?php echo e($user->phone ?? 'غير متوفر'); ?>

                                    </td>
                                    <td>
                                        <?php if($user->documents && count($user->documents) > 0): ?>
                                            <?php $__currentLoopData = $user->documents; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $doc): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                                <a href="<?php echo e(Storage::url($doc)); ?>" target="_blank" class="badge bg-info me-1">
                                                    <i class="fas fa-file"></i> وثيقة <?php echo e($loop->iteration); ?>

                                                </a>
                                            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                                        <?php else: ?>
                                            <span class="text-muted">لا توجد وثائق</span>
                                        <?php endif; ?>
                                    </td>
                                    <td><?php echo e($user->created_at->diffForHumans()); ?></td>
                                    <td>
                                        <div class="btn-group">
                                            <button class="btn btn-sm btn-info" 
                                                    onclick="showUserDetails(<?php echo e($user->id); ?>)">
                                                <i class="fas fa-eye"></i> عرض
                                            </button>
                                            
                                            <form action="<?php echo e(url('admin/users/' . $user->id . '/approve')); ?>" 
                                                  method="POST" class="d-inline">
                                                <?php echo csrf_field(); ?>
                                                <button type="submit" class="btn btn-sm btn-success">
                                                    <i class="fas fa-check"></i> موافقة
                                                </button>
                                            </form>
                                            
                                            <form action="<?php echo e(url('admin/users/' . $user->id . '/reject')); ?>" 
                                                  method="POST" class="d-inline">
                                                <?php echo csrf_field(); ?>
                                                <button type="submit" class="btn btn-sm btn-danger" 
                                                        onclick="return confirm('هل أنت متأكد من رفض هذا المستخدم؟')">
                                                    <i class="fas fa-times"></i> رفض
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                            </tbody>
                        </table>
                    </div>
                <?php endif; ?>
            </div>
        </div>
    </div>
</div>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.admin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH C:\Users\hp\Desktop\laravel\programming-language-project\resources\views/admin/users/pending.blade.php ENDPATH**/ ?>