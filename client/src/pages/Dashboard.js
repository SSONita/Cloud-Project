import { useState, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../api';
import { useAuth } from '../context/AuthContext';

const Dashboard = () => {
  const { user, logout, updateUser } = useAuth();
  const navigate = useNavigate();
  const fileInputRef = useRef(null);
  const [uploading, setUploading] = useState(false);
  const [uploadMsg, setUploadMsg] = useState('');
  const [dragOver, setDragOver] = useState(false);

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  const handleUpload = async (file) => {
    if (!file) return;
    if (!file.type.startsWith('image/')) {
      setUploadMsg('Only image files are allowed.');
      return;
    }
    if (file.size > 5 * 1024 * 1024) {
      setUploadMsg('File must be under 5 MB.');
      return;
    }

    setUploading(true);
    setUploadMsg('');

    const formData = new FormData();
    formData.append('image', file);

    try {
      const res = await api.post('/upload', formData, {
        headers: { 'Content-Type': 'multipart/form-data' },
      });
      updateUser({ image_url: res.data.image_url });
      setUploadMsg('Profile photo updated!');
    } catch (err) {
      setUploadMsg(err.response?.data?.error || 'Upload failed');
    } finally {
      setUploading(false);
    }
  };

  const onFileChange = (e) => handleUpload(e.target.files[0]);

  const onDrop = (e) => {
    e.preventDefault();
    setDragOver(false);
    handleUpload(e.dataTransfer.files[0]);
  };

  const avatarSrc = user?.image_url
    ? `http://localhost:8000${user.image_url}`
    : null;

  const initials = user?.name
    ?.split(' ')
    .map((n) => n[0])
    .join('')
    .toUpperCase()
    .slice(0, 2);

  return (
    <div className="dashboard">
      <header className="dash-header">
        <div className="dash-brand">⬡ CloudProject</div>
        <button className="btn-ghost" onClick={handleLogout}>Sign out</button>
      </header>

      <main className="dash-main">
        {/* Profile Card */}
        <section className="card profile-card">
          <div
            className={`avatar-zone ${dragOver ? 'drag-over' : ''}`}
            onDragOver={(e) => { e.preventDefault(); setDragOver(true); }}
            onDragLeave={() => setDragOver(false)}
            onDrop={onDrop}
            onClick={() => fileInputRef.current?.click()}
            title="Click or drop an image to update your photo"
          >
            {avatarSrc ? (
              <img src={avatarSrc} alt="Profile" className="avatar-img" />
            ) : (
              <div className="avatar-initials">{initials}</div>
            )}
            <div className="avatar-overlay">
              <span>{uploading ? 'Uploading…' : 'Change photo'}</span>
            </div>
          </div>

          <input
            ref={fileInputRef}
            type="file"
            accept="image/*"
            style={{ display: 'none' }}
            onChange={onFileChange}
          />

          <div className="profile-info">
            <h2>{user?.name}</h2>
            <p className="email">{user?.email}</p>
            {uploadMsg && (
              <p className={`upload-msg ${uploadMsg.includes('updated') ? 'success' : 'error'}`}>
                {uploadMsg}
              </p>
            )}
          </div>
        </section>

        {/* Account Details */}
        <section className="card details-card">
          <h3>Account Details</h3>
          <div className="detail-row">
            <span className="label">Name</span>
            <span className="value">{user?.name}</span>
          </div>
          <div className="detail-row">
            <span className="label">Email</span>
            <span className="value">{user?.email}</span>
          </div>
          <div className="detail-row">
            <span className="label">User ID</span>
            <span className="value mono">#{user?.id}</span>
          </div>
          <div className="detail-row">
            <span className="label">Profile Photo</span>
            <span className="value">{user?.image_url ? 'Uploaded ✓' : 'Not set'}</span>
          </div>
        </section>

        {/* Upload Instructions */}
        <section className="card upload-card">
          <h3>Update Profile Photo</h3>
          <div
            className={`drop-zone ${dragOver ? 'drag-over' : ''}`}
            onDragOver={(e) => { e.preventDefault(); setDragOver(true); }}
            onDragLeave={() => setDragOver(false)}
            onDrop={onDrop}
            onClick={() => fileInputRef.current?.click()}
          >
            <div className="drop-icon">↑</div>
            <p>Drag &amp; drop an image here</p>
            <p className="hint">or click to browse · JPG, PNG, GIF, WebP · max 5 MB</p>
          </div>
          {uploading && <div className="progress-bar"><div className="progress-fill" /></div>}
        </section>
      </main>
    </div>
  );
};

export default Dashboard;
