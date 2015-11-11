--Painful Escape
function c20513882.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(0)
	e1:SetCost(c20513882.cost)
	e1:SetTarget(c20513882.target)
	e1:SetOperation(c20513882.activate)
	c:RegisterEffect(e1)
end
function c20513882.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c20513882.cfilter(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and Duel.IsExistingMatchingCard(c20513882.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c:GetLevel(),c:GetRace(),c:GetAttribute(),c:GetCode())
end
function c20513882.thfilter(c,lv,race,att,code)
	return c:GetLevel()==lv and c:IsRace(race) and c:IsAttribute(att) and not c:IsCode(code) and c:IsAbleToHand()
end
function c20513882.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c20513882.cfilter,1,nil,e,tp)
	end
	local g=Duel.SelectReleaseGroup(tp,c20513882.cfilter,1,1,nil,e,tp)
	local rc=g:GetFirst()
	local label=bit.lshift(rc:GetRace(),16)
	label=label+bit.lshift(rc:GetLevel(),8)
	label=label+rc:GetAttribute()
	e:SetLabel(label)
	e:SetValue(rc:GetCode())
	Duel.Release(rc,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c20513882.activate(e,tp,eg,ep,ev,re,r,rp)
	local att=bit.band(e:GetLabel(),0xff)
	local lv=bit.band(bit.rshift(e:GetLabel(),8),0xff)
	local race=bit.rshift(e:GetLabel(),16)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c20513882.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,lv,race,att,e:GetValue())
	if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
