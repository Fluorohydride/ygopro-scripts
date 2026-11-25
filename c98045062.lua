--エネミーコントローラー
function c98045062.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_BATTLE_PHASE+TIMING_STANDBY_PHASE,TIMING_BATTLE_PHASE)
	e1:SetCost(c98045062.cost)
	e1:SetTarget(c98045062.target)
	e1:SetOperation(c98045062.activate)
	c:RegisterEffect(e1)
end
function c98045062.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(9)
	return true
end
function c98045062.filter1(c)
	return c:IsFaceup() and c:IsCanChangePosition()
end
function c98045062.filter2(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged(true)
end
function c98045062.cfilter(c,tp)
	return Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0
		and Duel.IsExistingTarget(c98045062.filter2,tp,0,LOCATION_MZONE,1,c)
end
function c98045062.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()==0 then
			return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c98045062.filter1(chkc)
		else
			return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c98045062.filter2(chkc)
		end
	end
	local b1=Duel.IsExistingTarget(c98045062.filter1,tp,0,LOCATION_MZONE,1,nil)
	local b2=nil
	if e:GetLabel()==9 then
		b2=Duel.CheckReleaseGroup(tp,c98045062.cfilter,1,nil,tp)
	else
		b2=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0
			and Duel.IsExistingTarget(c98045062.filter2,tp,0,LOCATION_MZONE,1,nil)
	end
	if chk==0 then
		e:SetLabel(0)
		return b1 or b2
	end
	local sel=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	if b1 and b2 then
		sel=Duel.SelectOption(tp,aux.Stringid(98045062,0),aux.Stringid(98045062,1))
	elseif b1 then
		sel=Duel.SelectOption(tp,aux.Stringid(98045062,0))
	else
		sel=Duel.SelectOption(tp,aux.Stringid(98045062,1))+1
	end
	if sel==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local g=Duel.SelectTarget(tp,c98045062.filter1,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	else
		if e:GetLabel()==9 then
			local rg=Duel.SelectReleaseGroup(tp,c98045062.cfilter,1,1,nil,tp)
			Duel.Release(rg,REASON_COST)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g=Duel.SelectTarget(tp,c98045062.filter2,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	end
	e:SetLabel(sel)
end
function c98045062.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if e:GetLabel()==0 then
			Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
		else
			Duel.GetControl(tc,tp,PHASE_END,1)
		end
	end
end
