--七皇再生
---@param c Card
function c83888009.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c83888009.cost)
	e1:SetTarget(c83888009.target)
	e1:SetOperation(c83888009.activate)
	c:RegisterEffect(e1)
end
function c83888009.costfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function c83888009.filter(c)
	return c:IsReleasable() and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c83888009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	local g=Duel.GetMatchingGroup(c83888009.costfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return g:GetCount()>0 and g:FilterCount(c83888009.filter,nil)==g:GetCount() and Duel.GetMZoneCount(tp,g)>0 end
	e:SetLabel(g:GetCount())
	Duel.Release(g,REASON_COST)
end
function c83888009.spfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c83888009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c83888009.spfilter(chkc,e,tp) end
	if chk==0 then
		if e:GetLabel()==100 then
			e:SetLabel(0)
			return Duel.IsExistingTarget(c83888009.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp)
		else
			return false
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c83888009.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c83888009.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c83888009.ovfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,tc)
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0
		and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(83888009,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg=g:Select(tp,1,e:GetLabel()+1,nil)
		Duel.Overlay(tc,sg)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetOperation(c83888009.damop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c83888009.ovfilter(c)
	local no=aux.GetXyzNumber(c)
	return no and no>=101 and no<=107 and c:IsType(TYPE_XYZ) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsCanOverlay()
end
function c83888009.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,83888009)
	Duel.Damage(tp,Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)*300,REASON_EFFECT)
	Duel.Damage(1-tp,Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)*300,REASON_EFFECT)
end
