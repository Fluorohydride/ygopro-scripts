--ダブルマジックアームバインド
---@param c Card
function c72621670.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c72621670.cost)
	e1:SetTarget(c72621670.target)
	e1:SetOperation(c72621670.activate)
	c:RegisterEffect(e1)
end
function c72621670.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c72621670.filter(c,check)
	return c:IsFaceup() and c:IsAbleToChangeControler(check)
end
function c72621670.fselect(g,tp)
	return Duel.GetMZoneCount(tp,g,tp,LOCATION_REASON_CONTROL)>1
		and Duel.CheckReleaseGroup(tp,aux.IsInGroup,g:GetCount(),nil,g)
		and Duel.IsExistingTarget(c72621670.filter,tp,0,LOCATION_MZONE,2,g,true)
end
function c72621670.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c72621670.filter(chkc,false) end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			local rg=Duel.GetReleaseGroup(tp)
			return rg:CheckSubGroup(c72621670.fselect,2,2,tp)
		else
			return Duel.IsExistingTarget(c72621670.filter,tp,0,LOCATION_MZONE,2,nil,false)
		end
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local rg=Duel.GetReleaseGroup(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=rg:SelectSubGroup(tp,c72621670.fselect,false,2,2,tp)
		aux.UseExtraReleaseCount(sg,tp)
		Duel.Release(sg,REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c72621670.filter,tp,0,LOCATION_MZONE,2,2,nil,false)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,2,0,0)
end
function c72621670.tfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsFaceup()
end
function c72621670.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c72621670.tfilter,nil,e)
	if g:GetCount()<2 then return end
	local rct=1
	if Duel.GetTurnPlayer()~=tp then rct=2 end
	Duel.GetControl(g,tp,PHASE_END,rct)
end
