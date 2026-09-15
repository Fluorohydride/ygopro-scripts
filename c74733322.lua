--神芸学都アルトメギア
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,97556336)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,97556336))
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_ANNOUNCE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCost(s.thcost)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
	--global resetter
	if not s.global_check then
		s.global_check=true
		s.announced={}
		s.announced_set={}
		s.clearop()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(s.clearop)
		Duel.RegisterEffect(ge1,0)
	end
end

-- workaround for Engraver
local ARTMEGIA_COUNT=4

function s.AddToAnnounced(tp,code)
	table.insert(s.announced[tp],code)
	s.announced_set[tp][code]=true
end

function s.clearop()
	s.announced[0]={}
	s.announced[1]={}
	s.announced_set[0]={}
	s.announced_set[1]={}
end

function s.costfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,s.costfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function s.anfilter(c,tp)
	return c:IsSetCard(0x1cd) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
		and not s.announced_set[tp][c:GetCode()]
end
function s.thfilter(c,code)
	return c:IsSetCard(0x1cd) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
		and c:IsCode(code)
end

function s.CreateCodeList(g,list,exg,exlist)
	local codes={}
	local existing={}
	-- exclude group
	if exg then
		for c in aux.Next(exg) do
			local code=c:GetCode()
			existing[code]=true
		end
	end
	-- exclude list
	if exlist then
		for _,code in ipairs(exlist) do
			existing[code]=true
		end
	end
	-- add group
	if g then
		for c in aux.Next(g) do
			local code=c:GetCode()
			if not existing[code] then
				existing[code]=true
				table.insert(codes,code)
			end
		end
	end
	-- add list
	if list then
		for _,code in ipairs(list) do
			if not existing[code] then
				existing[code]=true
				table.insert(codes,code)
			end
		end
	end
	table.sort(codes)
	return codes
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.anfilter,tp,LOCATION_DECK,0,nil,tp)
	local exg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local codes=s.CreateCodeList(g,nil,exg,nil)
	if chk==0 then return #codes>0 end
	local afilter={codes[1],OPCODE_ISCODE}
	if #codes>1 then
		--or ... or c:IsCode(codes[i])
		for i=2,#codes do
			table.insert(afilter,codes[i])
			table.insert(afilter,OPCODE_ISCODE)
			table.insert(afilter,OPCODE_OR)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp,table.unpack(afilter))
	s.AddToAnnounced(tp,ac)
	Duel.SetTargetParam(ac)
	getmetatable(e:GetHandler()).announce_filter=s.announce_filter_func
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thlimit(e,c,tp,re)
	return c:IsCode(e:GetLabel())
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,ac)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c)
	return not (c:IsSetCard(0x1cd) or c:IsCode(97556336)) and not c:IsLocation(LOCATION_EXTRA)
end

function s.announce_filter_func(e,tp,ev)
	local exg=Duel.GetMatchingGroup(aux.AND(Card.IsFaceup,Card.IsSetCard),tp,LOCATION_MZONE,0,nil,0x1cd)
	local ncodes=s.CreateCodeList(exg,s.announced[tp],nil,nil)
	if #ncodes>=ARTMEGIA_COUNT then
		return false
	end
	local af={
		TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT,
		0x1cd,OPCODE_ISSETCARD,OPCODE_AND,
		TYPE_MONSTER,OPCODE_ISTYPE,OPCODE_AND
	}
	for i=1,#ncodes do
		table.insert(af,ncodes[i])
		table.insert(af,OPCODE_ISCODE)
		table.insert(af,OPCODE_NOT)
		table.insert(af,OPCODE_AND)
	end
	return af
end
