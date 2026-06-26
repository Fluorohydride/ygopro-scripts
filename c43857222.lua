--ライブラの魔法秤
function c43857222.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--lv
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(43857222,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,43857222)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(c43857222.lvtg)
	e1:SetOperation(c43857222.lvop)
	c:RegisterEffect(e1)
end
function c43857222.lvfilter1(c,tp)
	return c:IsFaceup() and c:IsLevelAbove(2)
		and Duel.IsExistingTarget(c43857222.lvfilter2,tp,LOCATION_MZONE,0,1,c,1)
end
function c43857222.lvfilter2(c,lv)
	return c:IsFaceup() and c:IsLevelAbove(lv)
end
function c43857222.tgfilter(c,e)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsCanBeEffectTarget(e)
end
function c43857222.gcheck(g,lv)
	return g:IsExists(Card.IsLevelAbove,1,nil,lv+1)
end
function c43857222.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c43857222.lvfilter1,tp,LOCATION_MZONE,0,1,nil,tp) end
	local g=Duel.GetMatchingGroup(c43857222.tgfilter,tp,LOCATION_MZONE,0,nil,e)
	local _,lv=g:GetMaxGroup(Card.GetLevel)
	local alv=Duel.AnnounceLevel(tp,1,math.min(lv-1,6))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=g:SelectSubGroup(tp,c43857222.gcheck,false,2,2,alv)
	Duel.SetTargetCard(tg)
	e:SetLabel(alv)
end
function c43857222.lvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g==0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(43857222,1))
	local tc1=g:FilterSelect(tp,c43857222.lvfilter2,1,1,nil,lv+1):GetFirst()
	if tc1 then
		local c=e:GetHandler()
		local tc2=(g-tc1):GetFirst()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		if tc1:RegisterEffect(e1) and tc2 and tc2:IsFaceup() then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_LEVEL)
			e2:SetValue(lv)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc2:RegisterEffect(e2)
		end
	end
end
