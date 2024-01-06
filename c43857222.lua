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
		and Duel.IsExistingTarget(c43857222.lvfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c43857222.lvfilter2(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function c43857222.lvfilter3(c,tp,lv)
	return c:IsFaceup() and c:IsLevelAbove(lv+1)
		and Duel.IsExistingTarget(c43857222.lvfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c43857222.fselect(g,lv)
	local hc=g:GetFirst()
	local tc=g:GetNext()
	local res1=hc:IsFaceup() and tc:IsFaceup() and hc:IsLevelAbove(lv+1) and tc:IsLevelAbove(1)
	local res2=hc:IsFaceup() and tc:IsFaceup() and tc:IsLevelAbove(lv+1) and hc:IsLevelAbove(1)
	return res1 or res2
end
function c43857222.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c43857222.lvfilter1,tp,LOCATION_MZONE,0,1,nil,tp) end
	local g=Duel.GetMatchingGroup(c43857222.lvfilter1,tp,LOCATION_MZONE,0,nil,tp)
	g=g:Filter(Card.IsCanBeEffectTarget,nil,e)
	local mg,lv=g:GetMaxGroup(Card.GetLevel)
	local alv=0
	if lv>2 then alv=Duel.AnnounceLevel(tp,1,math.min(lv-1,6))
	else alv=Duel.AnnounceLevel(tp,1,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local tg=g:SelectSubGroup(tp,c43857222.fselect,false,2,2,alv)
	Duel.SetTargetCard(tg)
	e:SetLabel(alv)
end
function c43857222.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetTargetsRelateToChain()
	if #g<2 or g:IsExists(Card.IsFacedown,1,nil) or g:FilterCount(Card.IsLevelAbove,nil,1)<2 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(43857222,1))
	local hc=g:Filter(Card.IsLevelAbove,nil,lv+1):Select(tp,1,1,nil):GetFirst()
	local tc=g:GetFirst()
	if tc==hc then tc=g:GetNext() end
	if hc:IsFaceup() and hc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		hc:RegisterEffect(e1)
		if tc:IsFaceup() and tc:IsRelateToEffect(e) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_LEVEL)
			e2:SetValue(lv)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
		end
	end
end
