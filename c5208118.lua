--動点するP
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x73)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.cttg)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
	--move
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.seqtg)
	e3:SetOperation(s.seqop)
	c:RegisterEffect(e3)
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x73)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:AddCounter(0x73,1)
end
function s.cfilter(c)
	local seq=c:GetSequence()
	local tp=c:GetControler()
	if seq>4 or not c:IsType(TYPE_PENDULUM) or c:IsFacedown() then return false end
	return (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
end
function s.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.cfilter(chkc) end
	if chk==0 then return c:GetCounter(0x73)>0 and Duel.IsExistingTarget(s.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	Duel.SelectTarget(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function s.lv_or_rk(c)
	if c:IsType(TYPE_FUSION) then
		return c:GetLevel()
	elseif c:IsType(TYPE_XYZ) then
		return c:GetRank()
	end
	return 0
end
function s.desfilter(c,tp,p)
	return c:IsFaceup() and c:IsControler(1-tp)
		and s.lv_or_rk(c)>0
		and s.lv_or_rk(c)<=p
end
function s.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToChain() then return end
	if c:GetCounter(0x73)==0 then return end
	local ct=c:GetCounter(0x73)
	while ct>0 do
		local seq=tc:GetSequence()
		if seq>4 then return end
		local flag=0
		if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=flag|(1<<(seq-1)) end
		if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=flag|(1<<(seq+1)) end
		if flag==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local ss=Duel.SelectField(tp,1,LOCATION_MZONE,0,~flag)
		local nseq=math.log(ss,2)
		Duel.MoveSequence(tc,nseq)
		ct=ct-1
	end
	if ct==0 then
		local g=tc:GetColumnGroup():Filter(s.desfilter,tc,tp,tc:GetLeftScale())
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Destroy(g,REASON_EFFECT)
			local og=Duel.GetOperatedGroup()
			local dam=og:GetSum(Card.GetPreviousAttackOnField)
			if dam>0 then
				Duel.Damage(1-tp,dam,REASON_EFFECT)
			end
		end
	end
end
