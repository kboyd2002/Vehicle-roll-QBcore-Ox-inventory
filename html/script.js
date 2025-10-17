let spinActive = false;

// Listen for messages from Lua
window.addEventListener('message', function(event) {
    const data = event.data;
    
    if (data.action === 'openSpin') {
        openSpinner(data.vehicles, data.wonVehicle, data.spinDuration, data.tierColors);
    } else if (data.action === 'closeSpin') {
        closeSpinner();
    }
});

function openSpinner(vehicles, wonVehicle, duration, tierColors) {
    if (spinActive) return;
    spinActive = true;
    
    // Show container
    $('#spinContainer').removeClass('hidden');
    
    // Clear previous carousel
    $('#carousel').empty();
    
    // Create extended vehicle list for infinite effect
    const extendedVehicles = [];
    const repeatCount = 5; // Repeat the list multiple times
    
    for (let i = 0; i < repeatCount; i++) {
        extendedVehicles.push(...vehicles);
    }
    
    // Add won vehicle in the middle
    const middleIndex = Math.floor(extendedVehicles.length / 2);
    extendedVehicles[middleIndex] = wonVehicle;
    
    // Create vehicle cards
    extendedVehicles.forEach((vehicle, index) => {
        const card = $(`
            <div class="vehicle-card tier-${vehicle.tier}" data-index="${index}">
                <img src="images/${vehicle.image}" alt="${vehicle.label}" class="vehicle-image" onerror="this.src='https://via.placeholder.com/150x100?text=Vehicle'">
                <div class="vehicle-name">${vehicle.label}</div>
                <div class="vehicle-tier" style="color: ${tierColors[vehicle.tier]}">${vehicle.tier}</div>
            </div>
        `);
        $('#carousel').append(card);
    });
    
    // Calculate positions
    const cardWidth = 230; // 200px + 30px margin
    const totalWidth = extendedVehicles.length * cardWidth;
    const winningCardPosition = middleIndex * cardWidth;
    
    // Start position (far right)
    const startPosition = totalWidth - winningCardPosition - (cardWidth * 2);
    $('#carousel').css('transform', `translate(${startPosition}px, -50%)`);
    
    // Animate to winning position
    setTimeout(() => {
        const endPosition = -winningCardPosition + (window.innerWidth / 2) - (cardWidth / 2);
        
        $('#carousel').css({
            'transition': `transform ${duration}ms cubic-bezier(0.17, 0.67, 0.12, 0.99)`,
            'transform': `translate(${endPosition}px, -50%)`
        });
        
        // Show win overlay after spin completes
        setTimeout(() => {
            showWinOverlay(wonVehicle);
        }, duration);
        
    }, 100);
}

function showWinOverlay(vehicle) {
    $('#winVehicleName').text(vehicle.label);
    $('#winOverlay').removeClass('hidden');
    
    // Play celebration effect (you can add confetti library here)
    celebrateWin();
}

function celebrateWin() {
    // Simple celebration - you can enhance this with particles/confetti
    $('.win-content').css('animation', 'none');
    setTimeout(() => {
        $('.win-content').css('animation', 'scaleIn 0.5s ease');
    }, 10);
}

function closeSpinner() {
    $('#spinContainer').addClass('hidden');
    $('#winOverlay').addClass('hidden');
    $('#carousel').empty();
    spinActive = false;
}

// Close on ESC key (optional)
$(document).keyup(function(e) {
    if (e.key === "Escape" && spinActive) {
        $.post('https://vehicle_prize_system/closeSpin', JSON.stringify({}));
        closeSpinner();
    }
});