--D－HERO ドグマガイ
function c17132130.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17132130,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetValue(1)
	e2:SetCondition(c17132130.spcon)
	e2:SetOperation(c17132130.spop)
	c:RegisterEffect(e2)
	--special summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c17132130.lp)
	e3:SetOperation(c17132130.lpop)
	c:RegisterEffect(e3)
	c:EnableReviveLimit()
end
function c17132130.rfilter(c,tp)
	return c:IsSetCard(0xc008) and (c:IsControler(tp) or c:IsFaceup())
end
function c17132130.mzfilter(c,tp)
	return c:IsControler(tp) and c:GetSequence()<5
end
function c17132130.rmzfilter(c,tp)
	return c:IsSetCard(0xc008) and c:IsControler(tp) and c:GetSequence()<5
end
function c17132130.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	return ft>-3 and rg:GetCount()>2 and rg:IsExists(c17132130.rfilter,1,nil,tp)
		and (ft>0 or rg:IsExists(c17132130.mzfilter,ct,nil,tp))
		and (ft>-2 or rg:IsExists(c17132130.rmzfilter,1,nil,tp))
end
function c17132130.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetReleaseGroup(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>-2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,Card.IsSetCard,1,1,nil,0xc008)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,c17132130.rmzfilter,1,1,nil,tp)
	end
	local tc=g:GetFirst()
	if tc:IsControler(tp) and tc:GetSequence()<5 then ft=ft+1 end
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g2=rg:Select(tp,2,2,tc)
		g:Merge(g2)
	elseif ft>-1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g2=rg:FilterSelect(tp,c17132130.mzfilter,1,1,tc,tp)
		g:Merge(g2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g3=rg:Select(tp,1,1,g)
		g:Merge(g3)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g2=rg:FilterSelect(tp,c17132130.mzfilter,2,2,tc,tp)
		g:Merge(g2)
	end
	Duel.Release(g,REASON_COST)
end
function c17132130.lp(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c17132130.lpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17132130,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x2fe0000+RESET_PHASE+PHASE_STANDBY)
	e1:SetCondition(c17132130.lpc)
	e1:SetOperation(c17132130.lpcop)
	c:RegisterEffect(e1)
end
function c17132130.lpc(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c17132130.lpcop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)/2)
end
