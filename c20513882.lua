--苦渋の黙札
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
function c20513882.cfilter(c,tp)
	return c:GetOriginalLevel()>0
		and Duel.IsExistingMatchingCard(c20513882.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c)
end
function c20513882.thfilter(c,tc)
	return c:IsType(TYPE_MONSTER)
		and c:GetOriginalLevel()==tc:GetOriginalLevel()
		and c:GetOriginalRace()==tc:GetOriginalRace()
		and c:GetOriginalAttribute()==tc:GetOriginalAttribute()
		and not c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
		and c:IsAbleToHand()
end
function c20513882.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c20513882.cfilter,1,nil,tp)
	end
	local g=Duel.SelectReleaseGroup(tp,c20513882.cfilter,1,1,nil,tp)
	e:SetLabelObject(g:GetFirst())
	Duel.Release(g,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c20513882.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c20513882.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tc)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
