// ============================================
// API Configuration - Handles both local and EC2
// ============================================

function getAPIURL() {
  // If running locally (localhost/127.0.0.1)
  if (window.location.hostname === 'localhost' || 
      window.location.hostname === '127.0.0.1' ||
      window.location.hostname === '0.0.0.0') {
    return 'http://localhost:5000/api';
  }
  
  // For EC2 or any other IP/domain
  // Auto-detect from the URL bar hostname
  const protocol = window.location.protocol;
  const hostname = window.location.hostname;
  return protocol + '//' + hostname + ':5000/api';
}

const API_URL = getAPIURL();

// Log API configuration for debugging
console.log('=== API Configuration ===');
console.log('Frontend URL:', window.location.href);
console.log('API URL:', API_URL);
console.log('========================');

// ============================================
// DOM Elements
// ============================================

const registrationForm = document.getElementById('registrationForm');
const messageBox = document.getElementById('message');
const studentsList = document.getElementById('studentsList');
const refreshBtn = document.getElementById('refreshBtn');
const searchInput = document.getElementById('searchInput');
const editModal = document.getElementById('editModal');
const editForm = document.getElementById('editForm');

let allStudents = [];

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    loadStudents();
    registrationForm.addEventListener('submit', handleRegistration);
    refreshBtn.addEventListener('click', loadStudents);
    searchInput.addEventListener('input', filterStudents);
    editForm.addEventListener('submit', handleEditSubmit);
});

// Load all students
async function loadStudents() {
    try {
        const response = await fetch(`${API_URL}/students`);
        if (!response.ok) throw new Error('Failed to load students');
        
        allStudents = await response.json();
        displayStudents(allStudents);
    } catch (error) {
        console.error('Error loading students:', error);
        studentsList.innerHTML = '<p class="empty-message">Failed to load students. Please try again later.</p>';
    }
}

// Display students in table
function displayStudents(students) {
    if (students.length === 0) {
        studentsList.innerHTML = '<p class="empty-message">No students registered yet. Start by adding a new student!</p>';
        return;
    }

    const tableHTML = `
        <table class="students-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>City</th>
                    <th>Enrollment Date</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                ${students.map(student => `
                    <tr>
                        <td>${student.id}</td>
                        <td>${student.name}</td>
                        <td>${student.email}</td>
                        <td>${student.phone}</td>
                        <td>${student.city}</td>
                        <td>${formatDate(student.enrollmentDate)}</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn btn-edit" onclick="openEditModal(${student.id})">Edit</button>
                                <button class="btn btn-danger" onclick="deleteStudent(${student.id})">Delete</button>
                            </div>
                        </td>
                    </tr>
                `).join('')}
            </tbody>
        </table>
    `;
    
    studentsList.innerHTML = tableHTML;
}

// Handle registration form submission
async function handleRegistration(e) {
    e.preventDefault();
    
    const formData = {
        name: document.getElementById('name').value,
        email: document.getElementById('email').value,
        phone: document.getElementById('phone').value,
        dateOfBirth: document.getElementById('dateOfBirth').value,
        gender: document.getElementById('gender').value,
        address: document.getElementById('address').value,
        city: document.getElementById('city').value,
        state: document.getElementById('state').value,
        zipCode: document.getElementById('zipCode').value
    };

    try {
        const response = await fetch(`${API_URL}/students`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(formData)
        });

        const data = await response.json();

        if (!response.ok) {
            throw new Error(data.error || 'Failed to register student');
        }

        showMessage('Student registered successfully! 🎉', 'success');
        registrationForm.reset();
        loadStudents();
    } catch (error) {
        console.error('Error:', error);
        showMessage(error.message, 'error');
    }
}

// Show message
function showMessage(message, type) {
    messageBox.textContent = message;
    messageBox.className = `message-box ${type}`;
    messageBox.style.display = 'block';
    
    setTimeout(() => {
        messageBox.style.display = 'none';
    }, 5000);
}

// Filter students by search
function filterStudents() {
    const searchTerm = searchInput.value.toLowerCase();
    
    const filteredStudents = allStudents.filter(student => 
        student.name.toLowerCase().includes(searchTerm) ||
        student.email.toLowerCase().includes(searchTerm)
    );
    
    displayStudents(filteredStudents);
}

// Open edit modal
async function openEditModal(id) {
    try {
        const response = await fetch(`${API_URL}/students/${id}`);
        if (!response.ok) throw new Error('Failed to load student data');
        
        const student = await response.json();
        
        document.getElementById('editId').value = student.id;
        document.getElementById('editName').value = student.name;
        document.getElementById('editEmail').value = student.email;
        document.getElementById('editPhone').value = student.phone;
        document.getElementById('editDateOfBirth').value = student.dateOfBirth.split('T')[0];
        document.getElementById('editGender').value = student.gender;
        document.getElementById('editAddress').value = student.address;
        document.getElementById('editCity').value = student.city;
        document.getElementById('editState').value = student.state;
        document.getElementById('editZipCode').value = student.zipCode;
        
        editModal.style.display = 'flex';
    } catch (error) {
        console.error('Error:', error);
        showMessage('Failed to load student data', 'error');
    }
}

// Close modal
function closeModal() {
    editModal.style.display = 'none';
    editForm.reset();
}

// Close modal when clicking outside
editModal.addEventListener('click', (e) => {
    if (e.target === editModal) {
        closeModal();
    }
});

// Handle edit form submission
async function handleEditSubmit(e) {
    e.preventDefault();
    
    const studentId = document.getElementById('editId').value;
    
    const formData = {
        name: document.getElementById('editName').value,
        email: document.getElementById('editEmail').value,
        phone: document.getElementById('editPhone').value,
        dateOfBirth: document.getElementById('editDateOfBirth').value,
        gender: document.getElementById('editGender').value,
        address: document.getElementById('editAddress').value,
        city: document.getElementById('editCity').value,
        state: document.getElementById('editState').value,
        zipCode: document.getElementById('editZipCode').value
    };

    try {
        const response = await fetch(`${API_URL}/students/${studentId}`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(formData)
        });

        const data = await response.json();

        if (!response.ok) {
            throw new Error(data.error || 'Failed to update student');
        }

        showMessage('Student updated successfully! ✅', 'success');
        closeModal();
        loadStudents();
    } catch (error) {
        console.error('Error:', error);
        showMessage(error.message, 'error');
    }
}

// Delete student
async function deleteStudent(id) {
    if (!confirm('Are you sure you want to delete this student? This action cannot be undone.')) {
        return;
    }

    try {
        const response = await fetch(`${API_URL}/students/${id}`, {
            method: 'DELETE'
        });

        if (!response.ok) {
            throw new Error('Failed to delete student');
        }

        showMessage('Student deleted successfully! 🗑️', 'success');
        loadStudents();
    } catch (error) {
        console.error('Error:', error);
        showMessage('Failed to delete student', 'error');
    }
}

// Utility function to format date
function formatDate(dateString) {
    const options = { year: 'numeric', month: 'short', day: 'numeric' };
    return new Date(dateString).toLocaleDateString(undefined, options);
}
