--創星竜華－光巴
local s,id,o=GetID()
function s.initial_effect(c)
	c:SetSPSummonOnce(id)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_RELEASE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.thfilter(c)
	return c:IsSetCard(0x1c0) and c:IsAbleToHand()
		and not c:IsType(TYPE_PENDULUM)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if c:IsRelateToEffect(e) then
			Duel.BreakEffect()
			Duel.Destroy(c,REASON_EFFECT)
		end
	end
end
function s.spcfilter(c)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.spcfilter,1,e:GetHandler())
end
function s.rfilter(c,tp,ec)
	return c:IsSetCard(0x1c0) and c:IsReleasableByEffect()
		and c:IsLevel(10) and c:IsType(TYPE_MONSTER)
		and Duel.GetLocationCountFromEx(tp,tp,c,ec)>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.rfilter,tp,LOCATION_MZONE,0,c,tp,c)
	if chk==0 then return #g>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.desfilter(c,tp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or c:IsLocation(LOCATION_SZONE) and not c:IsLocation(LOCATION_FZONE)
end
function s.gcheck1(g,tp)
	return g:IsExists(s.desfilter,1,nil,tp)
end
function s.pfilter(c,tp)
	return bit.band(c:GetType(),TYPE_SPELL+TYPE_CONTINUOUS)==TYPE_SPELL+TYPE_CONTINUOUS
		and c:IsSetCard(0x1c0)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function s.gcheck2(g,tp)
	return g:GetCount()<=Duel.GetLocationCount(tp,LOCATION_SZONE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,s.rfilter,tp,LOCATION_MZONE,0,1,1,aux.ExceptThisCard(e),tp,c)
	if Duel.Release(g,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)~=0 then
		c:CompleteProcedure()
		if Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_ONFIELD,0,1,nil,tp)
			and Duel.IsExistingMatchingCard(s.pfilter,tp,LOCATION_DECK,0,1,nil,tp)
			and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			local rg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=rg:SelectSubGroup(tp,s.gcheck1,false,1,2,tp)
			local ct=Duel.Destroy(sg,REASON_EFFECT)
			if ct>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
				if ct>2 then ct=2 end
				local dg=Duel.GetMatchingGroup(s.pfilter,tp,LOCATION_DECK,0,nil,tp)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
				local pg=dg:SelectSubGroup(tp,s.gcheck2,false,1,ct,tp)
				for tc in aux.Next(pg) do
					Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				end
			end
		end
	end
end
