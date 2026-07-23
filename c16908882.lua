--No.104 仮面魔踏士 シャイニングＶ
local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,3)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.efcon)
	e2:SetOperation(s.efop)
	c:RegisterEffect(e2)
end
aux.xyz_number[id]=104
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.thfilter(c)
	return c:IsSetCard(0x176) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetCategory(CATEGORY_REMOVE)
	-- Under Duel.SpecialSummon(SUMMON_TYPE_XYZ), BE_MATERIAL fires after the single SPSUMMON_SUCCESS;
	-- use FIELD so it can catch the following field EVENT_SPSUMMON_SUCCESS (e.g. RUM - The Seventh One)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.rmcon)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler()) and e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_DECK)
end
function s.rmfilter(c,tp)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL) and c:IsAbleToRemove(tp)
end
function s.gcheck(g)
	if g:FilterCount(Card.IsType,nil,TYPE_SPELL)~=1 then return false end
	local sg=g:Filter(Card.IsType,nil,TYPE_MONSTER)
	if sg:GetCount()~=4 then return false end
	return aux.dabcheck(sg)
end
function s.rmgcheck(g)
	if g:FilterCount(Card.IsType,nil,TYPE_SPELL)>1 then return false end
	local sg=g:Filter(Card.IsType,nil,TYPE_MONSTER)
	if #sg>4 then return false end
	return aux.dabcheck(sg)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.rmfilter,tp,0,LOCATION_DECK,nil,1-tp)
	aux.GCheckAdditional=s.rmgcheck
	local res=g:IsExists(Card.IsType,1,nil,TYPE_SPELL) and g:CheckSubGroup(s.gcheck,5,5)
	if res and Duel.SelectYesNo(1-tp,aux.Stringid(id,3)) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg=g:SelectSubGroup(1-tp,s.gcheck,false,5,5)
		aux.GCheckAdditional=nil
		if sg then
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
	else
		aux.GCheckAdditional=nil
		local sg=Duel.GetDecktopGroup(1-tp,10)
		if #sg<=0 then return end
		Duel.DisableShuffleCheck()
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
