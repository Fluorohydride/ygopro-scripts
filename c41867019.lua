--魔妖遊行
function c41867019.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--choose effect
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,41867019+EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(c41867019.effcon)
	e2:SetTarget(c41867019.efftg)
	e2:SetOperation(c41867019.effop)
	c:RegisterEffect(e2)
end
function c41867019.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_ZOMBIE) and not c:IsSummonLocation(LOCATION_EXTRA)
end
function c41867019.setfilter(c)
	return c:IsSetCard(0x121) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and not c:IsCode(41867019)
end
function c41867019.tgfilter(c)
	return c:IsFaceup() and c:IsAbleToGrave()
end
function c41867019.effcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c41867019.cfilter,1,nil)
end
function c41867019.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetFlagEffect(tp,41867019)==0 then
			Duel.RegisterFlagEffect(tp,41867019,RESET_PHASE+PHASE_END,0,1)
		end
		local flag=Duel.GetFlagEffectLabel(tp,41867019)
		local b1=Duel.IsPlayerCanDraw(tp,1) and bit.band(flag,0x1)==0
		local b2=Duel.IsExistingMatchingCard(c41867019.setfilter,tp,LOCATION_DECK,0,1,nil) and bit.band(flag,0x2)==0
		local b3=Duel.IsExistingMatchingCard(c41867019.tgfilter,tp,0,LOCATION_MZONE,1,nil) and bit.band(flag,0x4)==0
		local b4=bit.band(flag,0x8)==0
		return b1 or b2 or b3 or b4
	end
end
function c41867019.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,41867019)==0 then
		Duel.RegisterFlagEffect(tp,41867019,RESET_PHASE+PHASE_END,0,1)
	end
	local flag=Duel.GetFlagEffectLabel(tp,41867019)
	local off=1
	local ops={}
	local opval={}
	local b1=Duel.IsPlayerCanDraw(tp,1) and bit.band(flag,0x1)==0
	local b2=Duel.IsExistingMatchingCard(c41867019.setfilter,tp,LOCATION_DECK,0,1,nil) and bit.band(flag,0x2)==0
	local b3=Duel.IsExistingMatchingCard(c41867019.tgfilter,tp,0,LOCATION_MZONE,1,nil) and bit.band(flag,0x4)==0
	local b4=bit.band(flag,0x8)==0
	if b1 then
		ops[off]=aux.Stringid(41867019,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(41867019,1)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(41867019,2)
		opval[off-1]=3
		off=off+1
	end
	if b4 then
		ops[off]=aux.Stringid(41867019,3)
		opval[off-1]=4
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	if sel==1 then
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.SetFlagEffectLabel(tp,41867019,flag|0x1)
	elseif sel==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c41867019.setfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SSet(tp,g)
		end
		Duel.SetFlagEffectLabel(tp,41867019,flag|0x2)
	elseif sel==3 then
		local g=Duel.GetMatchingGroup(c41867019.tgfilter,tp,0,LOCATION_MZONE,nil)
		if #g>0 then
			local tg=g:GetMinGroup(Card.GetAttack)
			if #tg>1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local sg=tg:Select(tp,1,1,nil)
				Duel.HintSelection(sg)
				Duel.SendtoGrave(sg,REASON_EFFECT)
			else
				Duel.SendtoGrave(tg,REASON_EFFECT)
			end
		end
		Duel.SetFlagEffectLabel(tp,41867019,flag|0x4)
	else
		Duel.Damage(1-tp,800,REASON_EFFECT)
		Duel.SetFlagEffectLabel(tp,41867019,flag|0x8)
	end
end
