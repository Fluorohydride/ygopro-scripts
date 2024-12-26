--炎魔の触媒
local s,id,o=GetID()
---@param c Card
function c40460013.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,40460013)
	e1:SetTarget(c40460013.sptg)
	e1:SetOperation(c40460013.spop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,40460013+o)
	e2:SetCondition(c40460013.thcon)
	e2:SetTarget(c40460013.thtg)
	e2:SetOperation(c40460013.thop)
	c:RegisterEffect(e2)
end
function c40460013.cfilter(c,e,tp,b1,b2)
	return c:IsRace(RACE_FIEND) and not c:IsPublic()
		and (b1 and c:IsDiscardable() or b2 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c40460013.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b2=c:IsDiscardable()
	if chk==0 then
		if c:IsPublic() then return false end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		if not b1 and not b2 then return false end
		return Duel.IsExistingMatchingCard(c40460013.cfilter,tp,LOCATION_HAND,0,1,c,e,tp,b1,b2)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c40460013.cfilter,tp,LOCATION_HAND,0,1,1,c,e,tp,b1,b2)
	local tc=g:GetFirst()
	Duel.SetTargetCard(tc)
	Duel.ConfirmCards(1-tp,tc)
	Duel.ShuffleHand(tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c40460013.checkfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40460013.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local mg=Group.FromCards(c,tc)
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=mg:FilterSelect(tp,c40460013.checkfilter,1,1,nil,e,tp)
		if #sg==0 then return end
		mg:RemoveCard(sg:GetFirst())
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		Duel.SendtoGrave(mg,REASON_EFFECT+REASON_DISCARD)
	end
end
function c40460013.thcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	return rc:IsRelateToBattle() and rc:IsControler(tp)
		and rc:IsFaceup() and rc:IsRace(RACE_FIEND)
end
function c40460013.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c40460013.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
