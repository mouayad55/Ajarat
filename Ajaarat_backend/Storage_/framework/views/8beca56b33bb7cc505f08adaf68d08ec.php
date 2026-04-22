

<?php $__env->startSection('title', 'إدارة المستخدمين'); ?>

<?php $__env->startSection('content'); ?>
<div class="row">
    <div class="col-12">
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0">جميع المستخدمين</h5>
                <a href="<?php echo e(url('admin/users/pending')); ?>" class="btn btn-warning">
                    <i class="fas fa-user-clock"></i> المستخدمين المعلقين
                    <?php if($pendingCount > 0): ?>
                        <span class="badge bg-danger"><?php echo e($pendingCount); ?></span>
                    <?php endif; ?>
                </a>
            </div>
            
            <div class="card-body">
                <?php if(session('success')): ?>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <?php echo e(session('success')); ?>

                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <?php endif; ?>
                
                <?php if(session('error')): ?>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <?php echo e(session('error')); ?>

                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <?php endif; ?>
                
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>الصورة</th>
                                <th> الاسم</th>
                                <th> الكنية </th>
                                <th>رقم الهاتف</th>
                                <th>الحالة</th>
                                <th>تاريخ التسجيل</th>
                                <th>الإجراءات</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php $__currentLoopData = $users; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $user): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                            <tr>
                                <td><?php echo e($loop->iteration); ?></td>
                                <td>
                                    <img src="<?php echo e($user->profile_image ?? 'https://ui-avatars.com/api/?name=' . urlencode($user->name) . '&background=random'); ?>" 
                                         class="user-avatar" alt="<?php echo e($user->name); ?>">
                                </td>
                                <td><?php echo e($user->first_name); ?></td>
                                <td><?php echo e($user->last_name); ?></td>
                                <td><?php echo e($user->phone ?? 'غير متوفر'); ?></td>
                                <td>
                                    <?php if($user->status == 'pending'): ?>
                                        <span class="status-badge status-pending">معلق</span>
                                    <?php elseif($user->status == 'approved'): ?>
                                        <span class="status-badge status-approved">مفعل</span>
                                    <?php elseif($user->status == 'rejected'): ?>
                                        <span class="status-badge status-rejected">مرفوض</span>
                                    <?php endif; ?>
                                </td>
                                <td><?php echo e($user->created_at->format('Y-m-d')); ?></td>
                                <td>
                                    <button class="btn btn-sm btn-info btn-action" 
                                            onclick="showUserDetails(<?php echo e($user->id); ?>)" 
                                            title="عرض التفاصيل">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    
                                    <?php if($user->status == 'pending'): ?>
                                        <form action="<?php echo e(url('admin/users/' . $user->id . '/approve')); ?>" 
                                              method="POST" style="display: inline;">
                                            <?php echo csrf_field(); ?>
                                            <button type="submit" class="btn btn-sm btn-success btn-action" title="موافقة">
                                                <i class="fas fa-check"></i>
                                            </button>
                                        </form>
                                        
                                        <form action="<?php echo e(url('admin/users/' . $user->id . '/reject')); ?>" 
                                              method="POST" style="display: inline;">
                                            <?php echo csrf_field(); ?>
                                            <button type="submit" class="btn btn-sm btn-danger btn-action" title="رفض">
                                                <i class="fas fa-times"></i>
                                            </button>
                                        </form>
                                    <?php endif; ?>
                                    
                                    <button class="btn btn-sm btn-danger btn-action" 
                                            onclick="confirmDelete(<?php echo e($user->id); ?>, '<?php echo e($user->first_name); ?>')"
                                            title="حذف المستخدم">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                    
                                    <!-- نموذج الحذف المخفي -->
                                    <form id="delete-form-<?php echo e($user->id); ?>" 
                                          action="<?php echo e(url('admin/users/' . $user->id)); ?>" 
                                          method="POST" style="display: none;">
                                        <?php echo csrf_field(); ?>
                                        <?php echo method_field('DELETE'); ?>
                                    </form>
                                </td>
                            </tr>
                            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                        </tbody>
                    </table>
                </div>
                
                <?php if($users->isEmpty()): ?>
                    <div class="text-center py-5">
                        <i class="fas fa-users fa-3x text-muted mb-3"></i>
                        <p class="text-muted">لا يوجد مستخدمين لعرضهم</p>
                    </div>
                <?php endif; ?>
                
                <!-- الترقيم -->
                <?php if($users->hasPages()): ?>
                    <div class="d-flex justify-content-center mt-4">
                        <?php echo e($users->links()); ?>

                    </div>
                <?php endif; ?>
            </div>
        </div>
    </div>
</div>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.admin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH C:\Users\hp\Desktop\laravel\programming-language-project\resources\views/admin/users/index.blade.php ENDPATH**/ ?>