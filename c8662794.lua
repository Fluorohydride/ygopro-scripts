--コードブレイカー・ゼロデイ
function c8662794.initial_effect(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c8662794.atktg)
	e1:SetValue(-1000)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8662794,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c8662794.descon)
	e2:SetTarget(c8662794.destg)
	e2:SetOperation(c8662794.desop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(8662794,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c8662794.srcon)
	e3:SetTarget(c8662794.srtg)
	e3:SetOperation(c8662794.srop)
	c:RegisterEffect(e3)
end
function c8662794.atktg(e,c)
	local lg1=c:GetLinkedGroup()
	local lg2=e:GetHandler():GetLinkedGroup()
	return c:IsFaceup() and c:IsType(TYPE_LINK) and not c:IsSetCard(0x13c)
		and (lg1 and lg1:IsContains(e:GetHandler()) or lg2 and lg2:IsContains(c))
end
function c8662794.desfilter(c)
	return c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousTypeOnField()&TYPE_LINK~=0 and c:IsPreviousSetCard(0x13c)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c8662794.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c8662794.desfilter,1,nil)
end
function c8662794.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
end
function c8662794.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c8662794.srcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c8662794.srfilter(c)
	return c:IsCode(8662794) and c:IsAbleToHand()
end
function c8662794.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8662794.srfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c8662794.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c8662794.srfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
